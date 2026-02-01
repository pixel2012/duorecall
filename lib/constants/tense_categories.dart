import 'package:flutter/material.dart';
import 'app_colors.dart';

class TenseCategory {
  final String id;
  final String name;
  final String englishName;
  final IconData icon;
  final Color color;
  final String example;

  const TenseCategory({
    required this.id,
    required this.name,
    required this.englishName,
    required this.icon,
    required this.color,
    required this.example,
  });
}

class TenseCategories {
  TenseCategories._();

  static const List<TenseCategory> all = [
    TenseCategory(
      id: 'simple_present',
      name: '一般现在时',
      englishName: 'Simple Present',
      icon: Icons.schedule,
      color: AppColors.simplePresent,
      example: 'I work every day.',
    ),
    TenseCategory(
      id: 'simple_past',
      name: '一般过去时',
      englishName: 'Simple Past',
      icon: Icons.history,
      color: AppColors.simplePast,
      example: 'I worked yesterday.',
    ),
    TenseCategory(
      id: 'simple_future',
      name: '一般将来时',
      englishName: 'Simple Future',
      icon: Icons.update,
      color: AppColors.simpleFuture,
      example: 'I will work tomorrow.',
    ),
    TenseCategory(
      id: 'present_continuous',
      name: '现在进行时',
      englishName: 'Present Continuous',
      icon: Icons.play_arrow,
      color: AppColors.presentContinuous,
      example: 'I am working now.',
    ),
    TenseCategory(
      id: 'past_continuous',
      name: '过去进行时',
      englishName: 'Past Continuous',
      icon: Icons.replay,
      color: AppColors.pastContinuous,
      example: 'I was working then.',
    ),
    TenseCategory(
      id: 'future_continuous',
      name: '将来进行时',
      englishName: 'Future Continuous',
      icon: Icons.fast_forward,
      color: AppColors.futureContinuous,
      example: 'I will be working.',
    ),
    TenseCategory(
      id: 'present_perfect',
      name: '现在完成时',
      englishName: 'Present Perfect',
      icon: Icons.done_all,
      color: AppColors.presentPerfect,
      example: 'I have worked here.',
    ),
    TenseCategory(
      id: 'past_perfect',
      name: '过去完成时',
      englishName: 'Past Perfect',
      icon: Icons.done_outline,
      color: AppColors.pastPerfect,
      example: 'I had worked before.',
    ),
    TenseCategory(
      id: 'future_perfect',
      name: '将来完成时',
      englishName: 'Future Perfect',
      icon: Icons.playlist_add_check,
      color: AppColors.futurePerfect,
      example: 'I will have finished.',
    ),
    TenseCategory(
      id: 'present_perfect_continuous',
      name: '现在完成进行时',
      englishName: 'Present Perfect Continuous',
      icon: Icons.trending_up,
      color: AppColors.presentPerfectContinuous,
      example: 'I have been working.',
    ),
    TenseCategory(
      id: 'past_perfect_continuous',
      name: '过去完成进行时',
      englishName: 'Past Perfect Continuous',
      icon: Icons.trending_flat,
      color: AppColors.pastPerfectContinuous,
      example: 'I had been working.',
    ),
    TenseCategory(
      id: 'future_perfect_continuous',
      name: '将来完成进行时',
      englishName: 'Future Perfect Continuous',
      icon: Icons.trending_down,
      color: AppColors.futurePerfectContinuous,
      example: 'I will have been working.',
    ),
    TenseCategory(
      id: 'past_future',
      name: '过去将来时',
      englishName: 'Past Future',
      icon: Icons.redo,
      color: AppColors.pastFuture,
      example: 'He said he would go.',
    ),
    TenseCategory(
      id: 'past_future_continuous',
      name: '过去将来进行时',
      englishName: 'Past Future Continuous',
      icon: Icons.loop,
      color: AppColors.pastFutureContinuous,
      example: 'He would be sleeping.',
    ),
    TenseCategory(
      id: 'past_future_perfect',
      name: '过去将来完成时',
      englishName: 'Past Future Perfect',
      icon: Icons.check_circle,
      color: AppColors.pastFuturePerfect,
      example: 'He would have arrived.',
    ),
    TenseCategory(
      id: 'past_future_perfect_continuous',
      name: '过去将来完成进行时',
      englishName: 'Past Future Perfect Continuous',
      icon: Icons.autorenew,
      color: AppColors.pastFuturePerfectContinuous,
      example: 'He would have been waiting.',
    ),
  ];

  static TenseCategory? getById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static TenseCategory getByIdOrDefault(String id) {
    return getById(id) ?? all.first;
  }
}
