import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/database_helper.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  int _totalCards = 0;
  int _masteredCards = 0;
  int _todayReviewed = 0;
  int _streakDays = 0;
  AppSettings _settings = AppSettings();

  int get totalCards => _totalCards;
  int get masteredCards => _masteredCards;
  int get todayReviewed => _todayReviewed;
  int get streakDays => _streakDays;
  AppSettings get settings => _settings;

  Future<void> loadStats() async {
    _totalCards = await _db.getSentenceCount();
    _masteredCards = await _db.getMasteredCount();
    _todayReviewed = await _db.getReviewedTodayCount();
    _streakDays = await _loadStreakDays();
    notifyListeners();
  }

  Future<void> loadSettings() async {
    final hintMode = await _db.getSetting('hint_mode') ?? HintMode.partial;
    final inputMode = await _db.getSetting('input_mode') ?? InputMode.manual;
    final theme = await _db.getSetting('theme') ?? 'system';
    final apiKey = await _db.getSetting('siliconflow_api_key');
    final dailyGoalStr = await _db.getSetting('daily_goal');

    _settings = AppSettings(
      hintMode: hintMode,
      inputMode: inputMode,
      theme: theme,
      siliconFlowApiKey: apiKey,
      dailyGoal: int.tryParse(dailyGoalStr ?? '') ?? 10,
    );
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    await _db.setSetting('hint_mode', newSettings.hintMode);
    await _db.setSetting('input_mode', newSettings.inputMode);
    await _db.setSetting('theme', newSettings.theme);
    if (newSettings.siliconFlowApiKey != null) {
      await _db.setSetting('siliconflow_api_key', newSettings.siliconFlowApiKey!);
    }
    await _db.setSetting('daily_goal', newSettings.dailyGoal.toString());
    notifyListeners();
  }

  Future<void> updateApiKey(String apiKey) async {
    _settings = _settings.copyWith(siliconFlowApiKey: apiKey);
    await _db.setSetting('siliconflow_api_key', apiKey);
    notifyListeners();
  }

  Future<int> _loadStreakDays() async {
    final lastStudyDateStr = await _db.getSetting('last_study_date');
    if (lastStudyDateStr == null) return 0;

    final lastStudyDate = DateTime.parse(lastStudyDateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(lastStudyDate.year, lastStudyDate.month, lastStudyDate.day);

    final difference = today.difference(lastDate).inDays;

    if (difference == 0) {
      return int.tryParse(await _db.getSetting('streak_days') ?? '0') ?? 0;
    } else if (difference == 1) {
      return int.tryParse(await _db.getSetting('streak_days') ?? '0') ?? 0;
    } else {
      await _db.setSetting('streak_days', '0');
      return 0;
    }
  }

  Future<void> updateStudyStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final lastStudyDateStr = await _db.getSetting('last_study_date');

    if (lastStudyDateStr != null) {
      final lastStudyDate = DateTime.parse(lastStudyDateStr);
      final lastDate = DateTime(lastStudyDate.year, lastStudyDate.month, lastStudyDate.day);
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        final currentStreak = int.tryParse(await _db.getSetting('streak_days') ?? '0') ?? 0;
        await _db.setSetting('streak_days', (currentStreak + 1).toString());
      } else if (difference > 1) {
        await _db.setSetting('streak_days', '1');
      }
    } else {
      await _db.setSetting('streak_days', '1');
    }

    await _db.setSetting('last_study_date', today.toIso8601String());
    await loadStats();
  }
}
