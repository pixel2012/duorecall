import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/sentence.dart';
import '../providers/sentence_provider.dart';

class ReviewPage extends StatefulWidget {
  final String filterType;
  final String filterValue;

  const ReviewPage({
    super.key,
    required this.filterType,
    required this.filterValue,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Sentence> _sentences = [];
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSentences();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadSentences() async {
    final provider = context.read<SentenceProvider>();
    List<Sentence> sentences = [];

    switch (widget.filterType) {
      case 'scene':
        sentences = await provider.getSentencesByScene(widget.filterValue);
        break;
      case 'tense':
        sentences = await provider.getSentencesByTense(widget.filterValue);
        break;
      case 'random':
        sentences = provider.sentences.toList()..shuffle();
        break;
      default:
        sentences = provider.sentences;
    }

    setState(() {
      _sentences = sentences;
    });
  }

  void _checkAnswer() {
    if (_sentences.isEmpty) return;

    final currentSentence = _sentences[_currentIndex];
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = currentSentence.englishText.trim().toLowerCase();

    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });

    final provider = context.read<SentenceProvider>();
    provider.incrementReviewCount(currentSentence.id!);

    if (!isCorrect) {
      provider.incrementErrorCount(currentSentence.id!);
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _sentences.length - 1) {
      setState(() {
        _currentIndex++;
        _showResult = false;
        _answerController.clear();
      });
    } else {
      _finishReview();
    }
  }

  void _finishReview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('复习完成'),
        content: const Text('恭喜你完成了本次复习！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sentences.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('复习'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentSentence = _sentences[_currentIndex];
    final progress = (_currentIndex + 1) / _sentences.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirm(),
        ),
        title: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.neutral,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_currentIndex + 1} / ${_sentences.length}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    '将下列句子翻译成英文',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentSentence.chineseText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!_showResult) ...[
              TextField(
                controller: _answerController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '请输入你的答案...',
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? AppColors.correctLight : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(
                      color: _isCorrect ? AppColors.success : AppColors.error,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? AppColors.success : AppColors.error,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isCorrect ? '太棒了！' : '再想想！',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isCorrect ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '标准答案',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentSentence.englishText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            if (!_showResult) ...[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.lightbulb),
                      label: const Text('提示'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      child: const Text('确定'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentIndex < _sentences.length - 1 ? '下一题' : '完成复习',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showExitConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确定退出复习？'),
        content: const Text('进度会自动保存'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
