/// Widgets 预览入口
///
/// 使用方法：
/// 1. 在 VSCode 中打开此文件
/// 2. 按 F5 选择 "Widgetbook" 启动配置
/// 3. 或在终端运行：flutter run -t lib/widgetbook.dart
///
/// 或者使用 VSCode 任务：
/// - Ctrl+Shift+P -> 运行任务 -> "Widgetbook: 生成并启动"
library;

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import '../constants/app_colors.dart';
import '../widgets/widgets.dart';

/// 主预览入口
void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const WidgetsPreviewApp(),
    ),
  );
}

class WidgetsPreviewApp extends StatelessWidget {
  const WidgetsPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgets Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const WidgetsGallery(),
    );
  }
}

/// 组件画廊
class WidgetsGallery extends StatelessWidget {
  const WidgetsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('组件预览'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('AppHeader'),
          const AppHeader(title: '多邻记', showNotification: true),
          const SizedBox(height: 24),

          _buildSectionTitle('StatCard'),
          const StatCard(
            todayReviewed: 12,
            streakDays: 7,
            totalCards: 156,
            dailyGoal: 10,
          ),
          const SizedBox(height: 16),
          const StatCard(
            todayReviewed: 0,
            streakDays: 0,
            totalCards: 0,
            dailyGoal: 10,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('QuickStartButton'),
          QuickStartButton(onTap: () {}),
          const SizedBox(height: 24),

          _buildSectionTitle('CategoryCard'),
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
          const SizedBox(height: 24),

          _buildSectionTitle('SentenceCard'),
          SentenceCard(
            chineseText: '我今天早上吃了一碗面条',
            englishText: 'I ate a bowl of noodles this morning',
            scene: 'daily_life',
            reviewCount: 5,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          SentenceCard(
            chineseText: '请问洗手间在哪里？',
            englishText: 'Excuse me, where is the restroom?',
            scene: 'travel',
            reviewCount: 0,
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
