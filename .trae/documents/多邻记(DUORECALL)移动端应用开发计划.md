## 项目概述
基于设计文档开发 Flutter 跨平台英语学习应用，采用多邻国风格设计，支持图片导入、AI识别、句子复习等功能。

## 技术栈
- **框架**: Flutter 3.10.7+
- **状态管理**: Provider
- **本地数据库**: SQLite (sqflite)
- **HTTP请求**: dio
- **图片处理**: image_picker, image, exif

## 开发阶段

### 阶段1: 项目基础架构搭建
1. 更新 pubspec.yaml 添加所有依赖
2. 创建项目目录结构 (models, services, providers, pages, widgets, utils, constants)
3. 配置主题色 (#58CC02 主题绿)
4. 创建数据库帮助类和表结构
5. 设置 Provider 状态管理架构

### 阶段2: 数据模型与数据库
1. 创建 Sentence 模型类
2. 创建 AiCache 模型类
3. 创建 ConversationHistory 模型类
4. 创建 Settings 模型类
5. 实现 DatabaseHelper 单例类
6. 创建所有表的 CRUD 操作

### 阶段3: 核心服务层
1. **SiliconFlowService**: AI API 调用服务
   - 视觉模型识别 (GLM-4V)
   - OCR 识别 (PaddleOCR/DeepSeek-OCR)
   - 大语言模型处理 (Qwen3-8B)
   - AI 语义判定
   - AI 解析生成
2. **ImageProcessingService**: 图片处理服务
   - 图片选择
   - EXIF 时间戳提取
   - 缩略图生成
3. **StorageService**: 数据导入导出服务
   - JSON 导出/导入
   - CSV 导出
   - 数据库备份

### 阶段4: 页面开发
1. **首页 (HomePage)**: 学习统计、快速开始、分类入口
2. **导入页 (ImportPage)**: 图片选择、识别进度、结果预览
3. **复习选择页 (ReviewSelectionPage)**: 维度选择、分类列表
4. **复习页 (ReviewPage)**: 核心答题交互、AI解析抽屉
5. **卡片库页 (CardListPage)**: 卡片列表、搜索筛选
6. **卡片详情页 (CardDetailPage)**: 卡片信息、解析历史
7. **我的页 (ProfilePage)**: 设置、数据管理、API配置

### 阶段5: 组件与工具
1. 通用组件: 底部导航栏、按钮、卡片、弹窗
2. 分类图标和颜色映射
3. 工具类: 日期格式化、字符串处理
4. 常量定义: 时态分类、场景分类

### 阶段6: 功能集成与优化
1. 图片识别流程集成
2. 复习流程集成
3. 数据导入导出功能
4. 性能优化 (分页加载、缓存)
5. 错误处理和边界情况

## 文件结构
```
lib/
├── main.dart
├── app.dart
├── constants/
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── tense_categories.dart
│   └── scene_categories.dart
├── models/
│   ├── sentence.dart
│   ├── ai_cache.dart
│   ├── conversation_history.dart
│   └── settings.dart
├── services/
│   ├── database_helper.dart
│   ├── siliconflow_service.dart
│   ├── image_processing_service.dart
│   └── storage_service.dart
├── providers/
│   ├── app_provider.dart
│   ├── sentence_provider.dart
│   ├── review_provider.dart
│   └── import_provider.dart
├── pages/
│   ├── home_page.dart
│   ├── import_page.dart
│   ├── review_selection_page.dart
│   ├── review_page.dart
│   ├── card_list_page.dart
│   ├── card_detail_page.dart
│   └── profile_page.dart
└── widgets/
    ├── common/
    ├── home/
    ├── import/
    ├── review/
    └── cards/
```

## 预计工作量
- 阶段1: 1-2 小时
- 阶段2: 2-3 小时
- 阶段3: 3-4 小时
- 阶段4: 6-8 小时
- 阶段5: 2-3 小时
- 阶段6: 2-3 小时

**总计**: 16-23 小时

请确认此计划后，我将开始第一阶段开发。