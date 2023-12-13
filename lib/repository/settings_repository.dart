import 'package:shared_preferences/shared_preferences.dart';
import 'package:statuspage/bloc/settings/settings_state.dart';

class SettingsRepository {
  final String darkTheme = 'darkTheme';

  Future<SettingsState> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool cached = prefs.getBool(darkTheme) ?? false;
    return SettingsState(darkTheme: cached);
  }

  Future<void> write(SettingsState settings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkTheme, settings.darkTheme);
  }
}
