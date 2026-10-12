import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/settings/settings_cubit.dart';

class TopBar extends AppBar {
  TopBar({
    super.key,
    this.withTitle = true,
    this.switchTheme = true,
    this.refresh = true,
  });

  final bool withTitle;
  final bool switchTheme;
  final bool refresh;

  @override
  TopBarState createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: widget.withTitle ? const Text("Status Page") : null,
      actions: <Widget>[
        if (widget.switchTheme) buildSwitchTheme(),
        if (widget.refresh) buildLastUpdate(),
        if (widget.refresh) buildRefresh(),
        buildGithubLogin(),
      ],
    );
  }

  Widget buildGithubLogin() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => IconButton(
        tooltip:
            state.githubAuthenticated ? 'GitHub connesso' : 'Accedi con GitHub',
        onPressed:
            state.githubAuthenticated ? null : () => openGithubLogin(state),
        icon: const FaIcon(FontAwesomeIcons.github),
      ),
    );
  }

  Future<void> openGithubLogin(AppState state) async {
    final cubit = context.read<AppCubit>();
    if (!state.githubLoginInProgress) {
      unawaited(cubit.loginWithGithub());
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocListener<AppCubit, AppState>(
        listenWhen: (previous, current) =>
            !previous.githubAuthenticated && current.githubAuthenticated,
        listener: (context, state) => Navigator.of(context).pop(),
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => AlertDialog(
            title: const Text('Accedi con GitHub'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.githubLoginInProgress && state.githubUserCode == null)
                  const LinearProgressIndicator(),
                if (state.githubUserCode != null) ...[
                  Text(state.githubLoginMessage ?? ''),
                  const SizedBox(height: 12),
                  SelectableText(
                    state.githubUserCode!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: state.githubVerificationUri == null
                        ? null
                        : () => launchGithubVerification(
                              state.githubVerificationUri!,
                            ),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Apri GitHub'),
                  ),
                ] else if (state.githubLoginMessage != null) ...[
                  Text(state.githubLoginMessage!),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (state.githubLoginInProgress) {
                    context.read<AppCubit>().cancelGithubLogin();
                  }
                  Navigator.of(dialogContext).pop();
                },
                child: Text(state.githubLoginInProgress ? 'Annulla' : 'Chiudi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchGithubVerification(String uri) async {
    await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
  }

  Padding buildSwitchTheme() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return IconButton(
            tooltip:
                state.darkTheme ? 'Attiva tema chiaro' : 'Attiva tema scuro',
            onPressed: () => context.read<SettingsCubit>().toggle(),
            icon: Icon(state.darkTheme ? Icons.dark_mode : Icons.light_mode),
          );
        },
      ),
    );
  }

  Padding buildRefresh() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => IconButton(
          tooltip:
              state.isRefreshing ? 'Aggiornamento in corso' : 'Aggiorna dati',
          onPressed: state.isRefreshing ? null : updateData,
          icon: state.isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
        ),
      ),
    );
  }

  StreamBuilder<String?> buildLastUpdate() {
    return StreamBuilder(
        stream: lastUpdatedStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final updatedAt = snapshot.data is String
              ? DateTime.tryParse(snapshot.data as String)
              : null;
          if (updatedAt == null) {
            return const SizedBox.shrink();
          }
          final label = _formatElapsed(DateTime.now().difference(updatedAt));
          final showLabel = MediaQuery.of(context).size.width >= 700;
          return Center(
            child: Tooltip(
              message: label,
              child: Semantics(
                label: label,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: showLabel
                      ? Text(label)
                      : const Icon(Icons.schedule, size: 20),
                ),
              ),
            ),
          );
        });
  }

  String _formatElapsed(Duration elapsed) {
    if (elapsed.inSeconds < 60) {
      return 'Aggiornato ora';
    }
    if (elapsed.inMinutes < 60) {
      return 'Aggiornato ${elapsed.inMinutes} min fa';
    }
    if (elapsed.inHours < 24) {
      return 'Aggiornato ${elapsed.inHours} ore fa';
    }
    return 'Aggiornato ${elapsed.inDays} giorni fa';
  }

  Stream<String?> lastUpdatedStream() async* {
    final prefs = await SharedPreferences.getInstance();
    yield prefs.getString(lastUpdatedKey);
    yield* Stream.periodic(
      const Duration(minutes: 1),
      (_) => prefs.getString(lastUpdatedKey),
    );
  }

  Future<void> updateData() async {
    await emptyCache();
    if (mounted) await context.read<AppCubit>().empty();
  }

  Future<void> emptyCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = <String>{lastUpdatedKey};
    for (final projects in [projectsCore, projectsTouchPoint]) {
      for (final teamProjects in projects.values) {
        for (final project in teamProjects) {
          final product = project['product'];
          keys
            ..add('$product-info-DEV')
            ..add('$product-info-UAT')
            ..add('$product-info-PROD')
            ..add('$product-release');
        }
      }
    }
    await Future.wait(keys.map(prefs.remove));
  }
}
