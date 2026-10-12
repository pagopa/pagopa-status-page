class AppState {
  Map<String, String> repoVersion;
  Map<String, String> devVersion;
  Map<String, String> uatVersion;
  Map<String, String> prodVersion;
  bool githubRateLimited;
  bool githubRateLimitBannerDismissed;
  bool githubLoginInProgress;
  bool authChecking;
  bool authPromptVisible;
  bool accessGranted;
  bool githubAuthenticated;
  bool isRefreshing;
  String? githubUserCode;
  String? githubVerificationUri;
  String? githubLoginMessage;

  AppState({
    required this.repoVersion,
    required this.devVersion,
    required this.uatVersion,
    required this.prodVersion,
    this.githubRateLimited = false,
    this.githubRateLimitBannerDismissed = false,
    this.githubLoginInProgress = false,
    this.authChecking = true,
    this.authPromptVisible = false,
    this.accessGranted = false,
    this.githubAuthenticated = false,
    this.isRefreshing = false,
    this.githubUserCode,
    this.githubVerificationUri,
    this.githubLoginMessage,
  });

  AppState copyWith({
    Map<String, String>? repoVersion,
    Map<String, String>? devVersion,
    Map<String, String>? uatVersion,
    Map<String, String>? prodVersion,
    bool? githubRateLimited,
    bool? githubRateLimitBannerDismissed,
    bool? githubLoginInProgress,
    bool? authChecking,
    bool? authPromptVisible,
    bool? accessGranted,
    bool? githubAuthenticated,
    bool? isRefreshing,
    String? githubUserCode,
    String? githubVerificationUri,
    String? githubLoginMessage,
    bool clearGithubLoginData = false,
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
      githubRateLimited: githubRateLimited ?? this.githubRateLimited,
      githubRateLimitBannerDismissed:
          githubRateLimitBannerDismissed ?? this.githubRateLimitBannerDismissed,
      githubLoginInProgress:
          githubLoginInProgress ?? this.githubLoginInProgress,
      authChecking: authChecking ?? this.authChecking,
      authPromptVisible: authPromptVisible ?? this.authPromptVisible,
      accessGranted: accessGranted ?? this.accessGranted,
      githubAuthenticated: githubAuthenticated ?? this.githubAuthenticated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      githubUserCode:
          clearGithubLoginData ? null : githubUserCode ?? this.githubUserCode,
      githubVerificationUri: clearGithubLoginData
          ? null
          : githubVerificationUri ?? this.githubVerificationUri,
      githubLoginMessage: githubLoginMessage ??
          (clearGithubLoginData ? null : this.githubLoginMessage),
    );
  }
}
