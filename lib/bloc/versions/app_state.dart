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
      repoVersion: repoVersion != null
          ? Map<String, String>.from(repoVersion)
          : this.repoVersion,
      devVersion: devVersion != null
          ? Map<String, String>.from(devVersion)
          : this.devVersion,
      uatVersion: uatVersion != null
          ? Map<String, String>.from(uatVersion)
          : this.uatVersion,
      prodVersion: prodVersion != null
          ? Map<String, String>.from(prodVersion)
          : this.prodVersion,
    );
  }
}
