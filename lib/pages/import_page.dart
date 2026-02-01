import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/sentence.dart';
import '../providers/sentence_provider.dart';
import '../services/image_processing_service.dart';
import '../services/siliconflow_service.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final ImageProcessingService _imageService = ImageProcessingService();
  final SiliconFlowService _aiService = SiliconFlowService();

  List<File> _selectedImages = [];
  List<Sentence> _recognizedSentences = [];
  bool _isProcessing = false;
  int _currentProgress = 0;

  Future<void> _pickImages() async {
    final images = await _imageService.pickImages();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
        _recognizedSentences = [];
      });
    }
  }

  Future<void> _startRecognition() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _currentProgress = 0;
    });

    final List<Sentence> allSentences = [];

    for (int i = 0; i < _selectedImages.length; i++) {
      setState(() {
        _currentProgress = i + 1;
      });

      final image = _selectedImages[i];
      final timestamp = await _imageService.extractTimestamp(image);
      final savedPath = await _imageService.saveImageToAppDirectory(image);

      try {
        final sentences = await _aiService.processImagesWithVision([image]);
        for (var sentence in sentences) {
          allSentences.add(sentence.copyWith(
            sourceTime: timestamp,
            imagePath: savedPath,
          ));
        }
      } catch (e) {
        print('Failed to process image $i: $e');
      }
    }

    setState(() {
      _isProcessing = false;
      _recognizedSentences = allSentences;
    });
  }

  Future<void> _saveSentences() async {
    if (_recognizedSentences.isEmpty) return;

    final provider = context.read<SentenceProvider>();
    await provider.addSentences(_recognizedSentences);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成功保存 ${_recognizedSentences.length} 张卡片')),
      );
      setState(() {
        _selectedImages = [];
        _recognizedSentences = [];
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _recognizedSentences = [];
    });
  }

  void _clearImages() {
    setState(() {
      _selectedImages = [];
      _recognizedSentences = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入图片'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : _recognizedSentences.isNotEmpty
              ? _buildResultView()
              : _buildSelectionView(),
    );
  }

  Widget _buildSelectionView() {
    return Column(
      children: [
        Expanded(
          child: _selectedImages.isEmpty
              ? _buildEmptyState()
              : _buildImageGrid(),
        ),
        if (_selectedImages.isNotEmpty) _buildSelectedInfo(),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: GestureDetector(
        onTap: _pickImages,
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.neutral,
              style: BorderStyle.solid,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 64,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: 16),
              Text(
                '点击选择图片',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '支持多选，建议选择多邻国截图',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _selectedImages[index],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '已选择 ${_selectedImages.length} 张图片',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _pickImages,
            child: const Text('继续添加'),
          ),
          TextButton(
            onPressed: _clearImages,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('清空'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _selectedImages.isNotEmpty ? _startRecognition : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('开始识别'),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '识别过程中请勿退出应用',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '正在识别中...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '第 $_currentProgress 张 / 共 ${_selectedImages.length} 张',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: LinearProgressIndicator(
              value: _currentProgress / _selectedImages.length,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              setState(() {
                _isProcessing = false;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('取消识别'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.correctLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 12),
              Text(
                '成功识别 ${_recognizedSentences.length} 张',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recognizedSentences.length,
            itemBuilder: (context, index) {
              final sentence = _recognizedSentences[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sentence.chineseText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sentence.englishText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(sentence.scene),
                          const SizedBox(width: 8),
                          _buildTag(sentence.tense),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _recognizedSentences = [];
                    });
                  },
                  child: const Text('重新识别'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saveSentences,
                  child: const Text('保存到卡片库'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
