class SettingsState {
  bool darkTheme;

  SettingsState({this.darkTheme = false});

  SettingsState copyWith({bool? darkTheme}) {
    return SettingsState(
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }
}
