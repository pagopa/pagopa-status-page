import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

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

  void addRepo(repoName, version) {
    state.repoVersion.update(repoName, (value) => version, ifAbsent: () => version);
    return emit(state.copyWith(repoVersion: state.repoVersion));
  }


  void addDev(repoName, version) {
    state.devVersion.update(repoName, (value) => version, ifAbsent: () => version);
    return emit(state.copyWith(devVersion: state.devVersion));
  }


  void addUat(repoName, version) {
    state.uatVersion.update(repoName, (value) => version, ifAbsent: () => version);
    return emit(state.copyWith(uatVersion: state.uatVersion));
  }

  void addProd(repoName, version) {
    state.prodVersion.update(repoName, (value) => version, ifAbsent: () => version);
    return emit(state.copyWith(prodVersion: state.prodVersion));
  }



}
