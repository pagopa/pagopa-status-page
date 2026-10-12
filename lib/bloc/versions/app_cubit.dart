import 'dart:convert';
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/constant.dart';

class AppCubit extends Cubit<AppState> {
  static const githubClientId = "82d6ebcd7127e50877de";
  int _githubLoginAttempt = 0;

  AppCubit({
    Map<String, String>? repoVersion,
    Map<String, String>? devVersion,
    Map<String, String>? uatVersion,
    Map<String, String>? prodVersion,
  }) : super(AppState(
          repoVersion: repoVersion ?? {},
          devVersion: devVersion ?? {},
          uatVersion: uatVersion ?? {},
          prodVersion: prodVersion ?? {},
        ));

  void addAll() {
    addTeamProject(projectsCore);
    addTeamProject(projectsTouchPoint);
  }

  Future<void> initialize() async {
    final token = window.localStorage['gh_token'];
    if (token == null || token.isEmpty) {
      emit(state.copyWith(
        authChecking: false,
        authPromptVisible: true,
      ));
      return;
    }

    try {
      final response = await _validateGithubToken(token);
      if (response.statusCode == 200) {
        _continueWithGithub();
      } else if (response.statusCode == 401) {
        _requireGithubLogin('La sessione GitHub è scaduta. Accedi di nuovo.');
      } else {
        emit(state.copyWith(
          authChecking: false,
          authPromptVisible: true,
          githubLoginMessage:
              'Non è stato possibile verificare la sessione GitHub. Puoi riprovare o entrare come guest.',
        ));
      }
    } on http.ClientException {
      emit(state.copyWith(
        authChecking: false,
        authPromptVisible: true,
        githubLoginMessage:
            'Connessione a GitHub non disponibile. Puoi riprovare o entrare come guest.',
      ));
    }
  }

  Future<http.Response> _validateGithubToken(String token) {
    return http.get(
      Uri.parse('https://api.github.com/rate_limit'),
      headers: {
        'X-GitHub-Api-Version': '2022-11-28',
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  void continueAsGuest() {
    window.localStorage.remove('gh_token');
    emit(state.copyWith(
      authChecking: false,
      authPromptVisible: false,
      accessGranted: true,
      githubAuthenticated: false,
      clearGithubLoginData: true,
    ));
    empty();
  }

  void _continueWithGithub() {
    emit(state.copyWith(
      authChecking: false,
      authPromptVisible: false,
      accessGranted: true,
      githubAuthenticated: true,
      githubLoginInProgress: false,
      githubLoginMessage: 'Login completato.',
      clearGithubLoginData: true,
    ));
    empty();
  }

  void cancelGithubLogin() {
    _githubLoginAttempt++;
    emit(state.copyWith(
      githubLoginInProgress: false,
      clearGithubLoginData: true,
    ));
  }

  void _requireGithubLogin(String message) {
    window.localStorage.remove('gh_token');
    emit(state.copyWith(
      authChecking: false,
      authPromptVisible: true,
      accessGranted: false,
      githubAuthenticated: false,
      githubLoginInProgress: false,
      githubLoginMessage: message,
      clearGithubLoginData: true,
    ));
  }

  void addTeamProject(teamProject) {
    for (var namespace in teamProject.values) {
      for (var project in namespace) {
        addRepo(project);
        addDev(project);
        addUat(project);
        addProd(project);
      }
    }
  }

  Future<void> addRepo(project) async {
    final token = window.localStorage['gh_token'];
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/pagopa/${project['repository']}/releases/latest'),
      headers: {
        'X-GitHub-Api-Version': '2022-11-28',
        'Accept': 'application/vnd.github+json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    var version = 'No Release';
    if (response.statusCode == 200) {
      final release = jsonDecode(response.body) as Map<String, dynamic>;
      version = release['tag_name'] as String? ?? 'No Release';
    } else if (response.statusCode == 401 && token != null) {
      if (!state.authPromptVisible) {
        _requireGithubLogin('La sessione GitHub è scaduta. Accedi di nuovo.');
      }
      version = 'ERROR';
    } else if (_isRateLimitResponse(response)) {
      emit(state.copyWith(
        githubRateLimited: true,
      ));
      version = 'ERROR';
    }

    state.repoVersion.update(project['product'], (value) => version,
        ifAbsent: () => version);
    emit(state.copyWith(repoVersion: state.repoVersion));
  }

  bool _isRateLimitResponse(http.Response response) {
    if (response.statusCode == 429) {
      return true;
    }
    if (response.statusCode != 403) {
      return false;
    }
    if (response.headers['x-ratelimit-remaining'] == '0') {
      return true;
    }
    return response.body.toLowerCase().contains('rate limit');
  }

  void dismissGithubRateLimitBanner() {
    emit(state.copyWith(githubRateLimitBannerDismissed: true));
  }

  Future<void> loginWithGithub() async {
    if (state.githubLoginInProgress) {
      return;
    }
    final attempt = ++_githubLoginAttempt;
    if (githubClientId.isEmpty) {
      emit(state.copyWith(
        clearGithubLoginData: true,
        githubLoginMessage:
            'Login non configurato: impostare GITHUB_CLIENT_ID per la build.',
      ));
      return;
    }

    emit(state.copyWith(
      githubLoginInProgress: true,
      clearGithubLoginData: true,
    ));

    try {
      final deviceResponse = await http.post(
        Uri.parse('https://github.com/login/device/code'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'client_id': githubClientId}),
      );
      final deviceData = _decodeJsonResponse(deviceResponse);
      if (deviceResponse.statusCode != 200 ||
          deviceData['device_code'] is! String ||
          deviceData['user_code'] is! String ||
          deviceData['verification_uri'] is! String) {
        _finishGithubLogin(
            _oauthErrorMessage(deviceData, 'Impossibile avviare il login.'));
        return;
      }

      emit(state.copyWith(
        githubUserCode: deviceData['user_code'] as String,
        githubVerificationUri: deviceData['verification_uri'] as String,
        githubLoginMessage: 'Inserisci il codice su GitHub per autorizzare.',
      ));

      final deviceCode = deviceData['device_code'] as String;
      final expiresIn = int.tryParse('${deviceData['expires_in']}') ?? 900;
      var interval = int.tryParse('${deviceData['interval']}') ?? 5;
      if (interval < 1) {
        interval = 5;
      }
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      while (DateTime.now().isBefore(expiresAt)) {
        await Future.delayed(Duration(seconds: interval));
        if (attempt != _githubLoginAttempt) {
          return;
        }
        final tokenResponse = await http.post(
          Uri.parse('https://github.com/login/oauth/access_token'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'client_id': githubClientId,
            'device_code': deviceCode,
            'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          }),
        );
        if (attempt != _githubLoginAttempt) {
          return;
        }
        final tokenData = _decodeJsonResponse(tokenResponse);
        final token = tokenData['access_token'];

        if (tokenResponse.statusCode == 200 && token is String) {
          final validation = await _validateGithubToken(token);
          if (attempt != _githubLoginAttempt) {
            return;
          }
          if (validation.statusCode == 200) {
            window.localStorage['gh_token'] = token;
            _continueWithGithub();
          } else {
            _finishGithubLogin(
                'GitHub non ha validato la sessione. Riprova il login.');
          }
          return;
        }

        final error = tokenData['error'];
        if (error == 'authorization_pending') {
          continue;
        }
        if (error == 'slow_down') {
          interval += 5;
          continue;
        }

        _finishGithubLogin(
          _oauthErrorMessage(tokenData, 'Autorizzazione GitHub non riuscita.'),
        );
        return;
      }

      _finishGithubLogin('Codice scaduto. Avvia nuovamente il login.');
    } on http.ClientException {
      _finishGithubLogin('Errore di rete durante il login GitHub.');
    } on FormatException {
      _finishGithubLogin('Risposta non valida dal servizio di login GitHub.');
    }
  }

  Map<String, dynamic> _decodeJsonResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw const FormatException('Expected a JSON object');
  }

  String _oauthErrorMessage(Map<String, dynamic> response, String fallback) {
    final description = response['error_description'];
    if (description is String && description.isNotEmpty) {
      return description;
    }
    final error = response['error'];
    if (error is String && error.isNotEmpty) {
      return error;
    }
    return fallback;
  }

  void _finishGithubLogin(String message) {
    emit(state.copyWith(
      githubLoginInProgress: false,
      githubLoginMessage: message,
    ));
  }

  Future<void> addDev(project) async {
    var url = apim_d + basePath + project['product'];
    String version = await fetchVersion(project, url);

    state.devVersion.update(project['product'], (value) => version,
        ifAbsent: () => version);
    return emit(state.copyWith(devVersion: state.devVersion));
  }

  Future<void> addUat(project) async {
    var url = apim_u + basePath + project['product'];
    String version = await fetchVersion(project, url);

    state.uatVersion.update(project['product'], (value) => version,
        ifAbsent: () => version);
    return emit(state.copyWith(uatVersion: state.uatVersion));
  }

  Future<void> addProd(project) async {
    var url = apim_p + basePath + project['product'];
    String version = await fetchVersion(project, url);

    state.prodVersion.update(project['product'], (value) => version,
        ifAbsent: () => version);
    return emit(state.copyWith(prodVersion: state.prodVersion));
  }

  void empty() {
    emit(state.copyWith(
      repoVersion: {},
      devVersion: {},
      uatVersion: {},
      prodVersion: {},
      githubRateLimited: false,
      githubRateLimitBannerDismissed: false,
    ));
    addAll();
  }

  Future<String> fetchVersion(project, url) {
    if (project["type"] == "frontend") {
      return fetchVersionFE(url);
    } else {
      return fetchVersionBE(url);
    }
  }

  Future<String> fetchVersionBE(url) async {
    var version = '';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      version = jsonDecode(response.body)['version'] ?? 'No Info Version';
    } else {
      if (response.bodyBytes.isEmpty) {
        version = 'Empty Body';
      } else {
        version = 'ERROR';
      }
    }
    return version;
  }

  Future<String> fetchVersionFE(url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      return jsonDecode(response.body)['version'] ?? 'No Info Version';
    } else {
      if (response.bodyBytes.isEmpty) {
        return 'Empty Body';
      } else {
        return 'ERROR';
      }
    }
  }
}
