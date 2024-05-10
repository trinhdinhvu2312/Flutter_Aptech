class AppConfig {
  final Map<String, dynamic> settings;
  final int selectedTabIndex;

  AppConfig({required this.settings, this.selectedTabIndex = 0});

  AppConfig copyWith({Map<String, dynamic>? settings, int? selectedTabIndex}) {
    return AppConfig(
      settings: settings ?? this.settings,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}
