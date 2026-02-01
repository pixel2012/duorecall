class AppSettings {
  final String hintMode;
  final String inputMode;
  final String theme;
  final String? siliconFlowApiKey;
  final int dailyGoal;

  AppSettings({
    this.hintMode = HintMode.partial,
    this.inputMode = InputMode.manual,
    this.theme = ThemeMode.system,
    this.siliconFlowApiKey,
    this.dailyGoal = 10,
  });

  static const String hintModeScrambled = 'scrambled';
  static const String hintModePartial = 'partial';
  static const String hintModeCategorized = 'categorized';

  static const String inputModeManual = 'manual';
  static const String inputModeSelect = 'select';

  static const String themeModeSystem = 'system';
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';

  Map<String, dynamic> toMap() {
    return {
      'hint_mode': hintMode,
      'input_mode': inputMode,
      'theme': theme,
      'siliconflow_api_key': siliconFlowApiKey,
      'daily_goal': dailyGoal,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      hintMode: map['hint_mode'] as String? ?? HintMode.partial,
      inputMode: map['input_mode'] as String? ?? InputMode.manual,
      theme: map['theme'] as String? ?? ThemeMode.system,
      siliconFlowApiKey: map['siliconflow_api_key'] as String?,
      dailyGoal: map['daily_goal'] as int? ?? 10,
    );
  }

  AppSettings copyWith({
    String? hintMode,
    String? inputMode,
    String? theme,
    String? siliconFlowApiKey,
    int? dailyGoal,
  }) {
    return AppSettings(
      hintMode: hintMode ?? this.hintMode,
      inputMode: inputMode ?? this.inputMode,
      theme: theme ?? this.theme,
      siliconFlowApiKey: siliconFlowApiKey ?? this.siliconFlowApiKey,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }
}

class HintMode {
  HintMode._();
  static const String scrambled = 'scrambled';
  static const String partial = 'partial';
  static const String categorized = 'categorized';
}

class InputMode {
  InputMode._();
  static const String manual = 'manual';
  static const String select = 'select';
}

class ThemeMode {
  ThemeMode._();
  static const String system = 'system';
  static const String light = 'light';
  static const String dark = 'dark';
}
