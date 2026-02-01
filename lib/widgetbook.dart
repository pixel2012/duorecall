import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'constants/app_colors.dart';

// 导入生成的 use cases
import 'widgetbook.directories.g.dart';

/// Widgetbook 主入口
///
/// 运行命令: flutter run -t lib/widgetbook.dart
void main() {
  runApp(const WidgetbookApp());
}

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // 自动生成的目录
      directories: directories,

      // 全局配置
      addons: [
        // 主题
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  secondary: AppColors.primaryDark,
                  surface: AppColors.cardBackground,
                  error: AppColors.error,
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  onSurface: AppColors.textPrimary,
                  onError: Colors.white,
                ),
              ),
            ),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),

        // 文本缩放
        TextScaleAddon(min: 0.5, max: 2.0, divisions: 4),

        // 本地化
        LocalizationAddon(
          locales: const [Locale('zh', 'CN'), Locale('en', 'US')],
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
        ),
      ],

      // 应用构建器
      appBuilder: (context, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: child);
      },
    );
  }
}
