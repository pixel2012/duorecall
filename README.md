# 多邻记 (DUORECALL)

AI 辅助英语句子记忆应用，帮助用户高效记忆多邻国等英语学习应用中的句子。

## 功能特性

- **图片导入识别**: 支持从相册选择或相机拍摄多邻国截图，AI 自动识别中英文句子
- **智能分类**: 自动识别场景分类（30+ 场景）和时态分类（16 种时态）
- **多种复习模式**: 支持按场景、时态、时间或随机复习
- **AI 解析**: 智能分析句子结构、固定搭配、相似表达
- **数据管理**: 支持 JSON/CSV 导入导出，数据库备份
- **学习统计**: 连续天数、复习次数、掌握进度追踪

## 技术栈

- **框架**: Flutter 3.10.7+
- **状态管理**: Provider
- **本地数据库**: SQLite (sqflite)
- **AI 服务**: SiliconFlow API
- **图片处理**: image_picker, image, exif

## 环境要求

- Flutter SDK ^3.10.7
- Dart SDK ^3.0.0
- Android SDK (Android 5.0+ 或 API 21+)
- Xcode (iOS 11.0+)

## 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd duorecall
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 配置 API Key（可选）

应用已内置默认 SiliconFlow API Key，如需使用自己的 Key：

1. 打开应用
2. 进入"我的"页面
3. 点击"硅基流动API密钥"
4. 输入你的 API Key

### 4. 运行应用

#### 开发模式

```bash
# 运行到默认设备
flutter run

# 运行到指定设备
flutter run -d <device-id>

# 调试模式
flutter run --debug

# 热重载（运行后按 r）
```

#### 查看可用设备

```bash
flutter devices
```

### 5. 组件预览（VSCode）

#### 方式一：组件预览（推荐，最简单）

这是最简单的预览方式，不需要额外配置，直接显示所有组件。

**方法 1：使用 VSCode 启动配置**
1. 按 `F5` 或点击左侧调试图标
2. 选择 **"组件预览 (Widgets Preview)"**
3. 点击运行按钮

**方法 2：使用 VSCode 任务**
1. 按 `Ctrl+Shift+P` 打开命令面板
2. 输入 "运行任务"
3. 选择 **"组件预览: 启动"**

**方法 3：命令行**
```bash
flutter run -t lib/preview/widgets_preview.dart
```

这个预览会显示一个组件画廊，包含：
- AppHeader
- StatCard（有数据/无数据两种状态）
- QuickStartButton
- CategoryCard
- SentenceCard

#### 方式二：Widgetbook（专业组件库管理）

Widgetbook 是一个专业的 Flutter 组件库管理工具，支持多设备预览、主题切换等功能。

```bash
# 1. 生成预览代码（修改组件后需要重新运行）
flutter pub run build_runner build --delete-conflicting-outputs

# 2. 运行 Widgetbook
flutter run -t lib/widgetbook.dart
```

或在 VSCode 中按 `F5` 选择 **"Widgetbook"** 启动配置。

**带 @UseCase 注解的组件：**

| 组件 | 文件 | 预览用例 |
|------|------|----------|
| AppHeader | `lib/widgets/app_header.dart` | Default, Without Notification |
| StatCard | `lib/widgets/stat_card.dart` | Default, Empty |
| CategoryCard | `lib/widgets/category_card.dart` | Default, Multiple |
| QuickStartButton | `lib/widgets/quick_start_button.dart` | Default |
| SentenceCard | `lib/widgets/sentence_card.dart` | Default, Long Text, No Review |

**添加新的预览组件：**

```dart
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: YourWidget)
Widget yourWidgetDefault(BuildContext context) {
  return YourWidget(
    // 配置参数
  );
}
```

然后运行代码生成命令。

#### 方式三：Device Preview（完整应用预览）

在设备框架中预览完整应用。

```bash
flutter run -t lib/preview/app_preview.dart
```

或在 VSCode 中选择启动配置 **"Device Preview"**。

### 6. 构建打包

#### Android APK

```bash
# 调试 APK
flutter build apk --debug

# 发布 APK
flutter build apk --release

# 输出路径: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (AAB)

```bash
# 用于 Google Play 上架
flutter build appbundle --release

# 输出路径: build/app/outputs/bundle/release/app-release.aab
```

#### iOS

```bash
# 需要 macOS 和 Xcode

# 构建 iOS 应用
flutter build ios --release

# 构建 iOS 框架（用于集成到现有项目）
flutter build ios-framework

# 构建 ipa（需要开发者账号）
flutter build ipa --release
```

#### Windows

```bash
flutter build windows --release

# 输出路径: build/windows/x64/runner/Release/
```

#### macOS

```bash
flutter build macos --release

# 输出路径: build/macos/Build/Products/Release/
```

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── app.dart                  # 应用配置和导航
├── constants/                # 常量定义
│   ├── app_colors.dart       # 主题颜色
│   ├── app_theme.dart        # 主题配置
│   ├── scene_categories.dart # 场景分类
│   └── tense_categories.dart # 时态分类
├── models/                   # 数据模型
│   ├── sentence.dart         # 句子模型
│   ├── ai_cache.dart         # AI 缓存
│   ├── conversation_history.dart
│   └── settings.dart         # 设置模型
├── services/                 # 服务层
│   ├── database_helper.dart  # 数据库操作
│   ├── siliconflow_service.dart  # AI API
│   ├── image_processing_service.dart
│   └── storage_service.dart  # 导入导出
├── providers/                # 状态管理
│   ├── app_provider.dart
│   └── sentence_provider.dart
└── pages/                    # 页面
    ├── home_page.dart
    ├── import_page.dart
    ├── review_selection_page.dart
    ├── review_page.dart
    ├── card_list_page.dart
    └── profile_page.dart
```

## 使用指南

### 导入句子

1. 点击底部导航栏"导入"
2. 选择多邻国截图（可多选）
3. 点击"开始识别"
4. 查看识别结果，确认后保存

### 开始复习

1. 点击首页"开始复习"或底部"首页"
2. 选择复习方式（场景/时态/时间/随机）
3. 选择具体分类
4. 根据中文提示输入英文翻译
5. 查看结果和解析

### 数据备份

1. 进入"我的"页面
2. 点击"导出数据"
3. 选择 JSON 或 CSV 格式
4. 文件将保存到应用目录

## 常见问题

### Q: 图片识别失败怎么办？

A: 确保截图清晰，包含完整的中英文句子。如果识别失败，可以手动添加句子。

### Q: 如何更换 API Key？

A: 在"我的"页面 -> "硅基流动API密钥"中设置。

### Q: 数据会丢失吗？

A: 数据保存在本地 SQLite 数据库中，卸载应用会丢失。建议定期导出备份。

## 开发计划

- [x] 基础架构搭建
- [x] 数据模型与数据库
- [x] AI 识别服务
- [x] 核心页面开发
- [x] 复习功能
- [ ] AI 解析抽屉
- [ ] 语音输入
- [ ] 学习提醒
- [ ] 云端同步

## 许可证

MIT License

## 联系方式

如有问题或建议，欢迎提交 Issue 或 PR。
