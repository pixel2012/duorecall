import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import '../app.dart';
import '../providers/app_provider.dart';
import '../providers/sentence_provider.dart';

/// 用于 VSCode 预览的入口
/// 
/// 在 VSCode 中安装 Flutter Preview 扩展后，
/// 可以在组件上右键选择 "Flutter: Open Preview" 预览
void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => SentenceProvider()),
        ],
        child: const DuorecallApp(),
      ),
    ),
  );
}
