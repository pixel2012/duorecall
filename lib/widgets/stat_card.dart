import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../constants/app_colors.dart';

/// 统计卡片组件
@UseCase(name: 'Default', type: StatCard)
Widget statCardDefault(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: const StatCard(
      todayReviewed: 12,
      streakDays: 7,
      totalCards: 156,
      dailyGoal: 10,
    ),
  );
}

@UseCase(name: 'Empty', type: StatCard)
Widget statCardEmpty(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: const StatCard(
      todayReviewed: 0,
      streakDays: 0,
      totalCards: 0,
      dailyGoal: 10,
    ),
  );
}

class StatCard extends StatelessWidget {
  final int todayReviewed;
  final int streakDays;
  final int totalCards;
  final int dailyGoal;

  const StatCard({
    super.key,
    required this.todayReviewed,
    required this.streakDays,
    required this.totalCards,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.local_fire_department,
                iconColor: AppColors.streak,
                value: todayReviewed.toString(),
                label: '今日已学',
              ),
              _buildStatItem(
                icon: Icons.calendar_today,
                iconColor: AppColors.primary,
                value: streakDays.toString(),
                label: '连续天数',
              ),
              _buildStatItem(
                icon: Icons.style,
                iconColor: AppColors.travel,
                value: totalCards.toString(),
                label: '卡片总数',
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: dailyGoal > 0 ? todayReviewed / dailyGoal : 0,
              minHeight: 4,
              backgroundColor: AppColors.neutral,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '今日目标：已完成 $todayReviewed/$dailyGoal 张',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
