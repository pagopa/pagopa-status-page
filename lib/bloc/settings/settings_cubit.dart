import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';
import 'package:statuspage/repository/settings_repository.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final repository = SettingsRepository();

  SettingsCubit() : super(SettingsState());

  Future<void> loadSettings() async {
    var newState =
        state.copyWith(darkTheme: (await repository.read()).darkTheme);
    emit(newState);
  }

  Future<void> toggle() async {
    var newState = state.copyWith(darkTheme: !state.darkTheme);
    await repository.write(newState);
    emit(newState);
  }
}
