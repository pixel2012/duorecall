import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../constants/app_colors.dart';

/// 分类卡片组件
@UseCase(name: 'Default', type: CategoryCard)
Widget categoryCardDefault(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CategoryCard(
                icon: Icons.category,
                color: AppColors.travel,
                title: '按场景',
                count: '12',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryCard(
                icon: Icons.schedule,
                color: AppColors.restaurant,
                title: '按时态',
                count: '8',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

@UseCase(name: 'Multiple', type: CategoryCard)
Widget categoryCardMultiple(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.background,
    child: GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        CategoryCard(
          icon: Icons.category,
          color: AppColors.travel,
          title: '按场景',
          count: '12',
          onTap: () {},
        ),
        CategoryCard(
          icon: Icons.schedule,
          color: AppColors.restaurant,
          title: '按时态',
          count: '8',
          onTap: () {},
        ),
        CategoryCard(
          icon: Icons.calendar_today,
          color: AppColors.primary,
          title: '按时间',
          count: '24',
          onTap: () {},
        ),
        CategoryCard(
          icon: Icons.shuffle,
          color: AppColors.shopping,
          title: '随机复习',
          count: '全部',
          onTap: () {},
        ),
      ],
    ),
  );
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String count;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
