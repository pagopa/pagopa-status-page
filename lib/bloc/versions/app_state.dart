class AppState {
  Map<String, String> repoVersion;
  Map<String, String> devVersion;
  Map<String, String> uatVersion;
  Map<String, String> prodVersion;

  AppState({
    required this.repoVersion,
    required this.devVersion,
    required this.uatVersion,
    required this.prodVersion,
  });

  AppState copyWith({
    Map<String, String>? repoVersion,
    Map<String, String>? devVersion,
    Map<String, String>? uatVersion,
    Map<String, String>? prodVersion,
  }) {
    return AppState(
      repoVersion: repoVersion ?? this.repoVersion,
      devVersion: devVersion ?? this.devVersion,
      uatVersion: uatVersion ?? this.uatVersion,
      prodVersion: prodVersion ?? this.prodVersion,
    );
  }
}
