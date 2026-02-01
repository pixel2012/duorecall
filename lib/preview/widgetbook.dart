import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import '../constants/app_colors.dart';

/// Widgetbook 预览配置
///
/// 运行命令: flutter run -t lib/preview/widgetbook.dart
/// 然后访问 http://localhost:xxxx
void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookFolder(
          name: 'Components',
          children: [
            WidgetbookComponent(
              name: 'Stat Card',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatItem(
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.streak,
                          value: '12',
                          label: '今日已学',
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          icon: Icons.calendar_today,
                          iconColor: AppColors.primary,
                          value: '7',
                          label: '连续天数',
                        ),
                        const SizedBox(height: 16),
                        _buildStatItem(
                          icon: Icons.style,
                          iconColor: AppColors.travel,
                          value: '156',
                          label: '卡片总数',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookFolder(
          name: 'Pages',
          children: [
            WidgetbookComponent(
              name: 'Home Page',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Scaffold(
                    backgroundColor: AppColors.background,
                    body: CustomScrollView(
                      slivers: [
                        _buildPreviewHeader(),
                        const SliverPadding(padding: EdgeInsets.only(top: 16)),
                        _buildPreviewStatsCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPhoneSE,
            Devices.android.samsungGalaxyS20,
            Devices.android.mediumPhone,
          ],
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),
      ],
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
          style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildPreviewHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '多邻记',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewStatsCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
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
                    value: '12',
                    label: '今日已学',
                  ),
                  _buildStatItem(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primary,
                    value: '7',
                    label: '连续天数',
                  ),
                  _buildStatItem(
                    icon: Icons.style,
                    iconColor: AppColors.travel,
                    value: '156',
                    label: '卡片总数',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 4,
                  backgroundColor: AppColors.neutral,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '今日目标：已完成 6/10 张',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
