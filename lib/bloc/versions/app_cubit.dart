import 'dart:convert';
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/constant.dart';

class AppCubit extends Cubit<AppState> {
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
    addTeamProject(projectsNodo5);
    addTeamProject(projectsVAS);
    // addTeamProject(projectsTouchPoint);
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
    // var parser = await Chaleno()
    //     .load('https://github.com/pagopa/${project['repository']}');
    // List<Result>? results = parser?.getElementsByClassName(
    //     'css-truncate css-truncate-target text-bold mr-2');
    // var version = results?.first.text ?? 'ERROR';

    final Storage storage = window.localStorage;

    http.Response response;
    if (storage['gh_token'] != null) {
      response = await http.get(
        Uri.parse(
            'https://api.github.com/repos/pagopa/${project['repository']}/releases/latest'),
        headers: <String, String>{
          'X-GitHub-Api-Version': '2022-11-28',
          'Authorization': 'Bearer ${storage['gh_token']}',
          'Accept': 'application/vnd.github+json'
        },
      ); // there are limitation 60 requests per hour
    } else {
      response = await http.get(Uri.parse(
          'https://api.github.com/repos/pagopa/${project['repository']}/releases/latest')); // there are limitation 60 requests per hour
    }
    var version = jsonDecode(response.body)['tag_name'] ?? 'No Release';

    state.repoVersion.update(project['product'], (value) => version,
        ifAbsent: () => version);
    return emit(state.copyWith(repoVersion: state.repoVersion));
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
        repoVersion: {}, devVersion: {}, uatVersion: {}, prodVersion: {}));
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
