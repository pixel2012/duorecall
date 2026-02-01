import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/sentence.dart';

class SiliconFlowService {
  static const String _baseUrl = 'https://api.siliconflow.cn/v1';
  static const String _defaultApiKey = 'sk-wmewhcwoftsdmnyzhzxutcsfgthpfcboogdfutrlrchaaayi';

  static const String _visionModel = 'THUDM/GLM-4.1V-9B-Thinking';
  static const String _ocrModel = 'PaddlePaddle/PaddleOCR-VL-1.5';
  static const String _llmModel = 'Qwen/Qwen3-8B';

  late Dio _dio;
  String _apiKey;

  SiliconFlowService({String? apiKey}) : _apiKey = apiKey ?? _defaultApiKey {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  void updateApiKey(String apiKey) {
    _apiKey = apiKey;
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
  }

  Future<List<Sentence>> processImagesWithVision(List<File> images) async {
    final results = <Sentence>[];

    for (final image in images) {
      try {
        final base64Image = await _fileToBase64(image);
        final sentences = await _recognizeWithVisionModel(base64Image, image.path);
        results.addAll(sentences);
      } catch (e) {
        print('Vision model failed for ${image.path}: $e');
        try {
          final sentences = await _processWithOcrAndLlm(image);
          results.addAll(sentences);
        } catch (e2) {
          print('OCR+LLM fallback failed for ${image.path}: $e2');
        }
      }
    }

    return results;
  }

  Future<List<Sentence>> _recognizeWithVisionModel(String base64Image, String imagePath) async {
    final prompt = '''
请分析这张图片中的中英文句子，并提取出所有的句子对。

要求：
1. 识别图片中的中文句子和对应的英文翻译
2. 对每个句子对进行分类：
   - 场景分类（从以下选择）：日常生活、餐厅用餐、购物消费、旅行出行、工作职场、学校教育、医疗健康、交通出行、住宿酒店、银行金融、邮局快递、电话通讯、天气气候、时间日期、家庭亲情、朋友社交、爱情约会、运动健身、娱乐休闲、音乐艺术、阅读书籍、科技网络、自然环境、动物宠物、节日庆典、新闻媒体、法律政务、面试求职、租房买房、其他场景
   - 时态分类（从以下选择）：一般现在时、一般过去时、一般将来时、现在进行时、过去进行时、将来进行时、现在完成时、过去完成时、将来完成时、现在完成进行时、过去完成进行时、将来完成进行时、过去将来时、过去将来进行时、过去将来完成时、过去将来完成进行时

3. 以JSON格式返回，格式如下：
{
  "sentences": [
    {
      "chinese": "中文句子",
      "english": "English sentence",
      "scene": "场景名称",
      "tense": "时态名称"
    }
  ],
  "confidence": 0.95
}

如果图片中没有清晰的句子对，请返回空数组。
''';    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': _visionModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': prompt},
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              },
            ],
          },
        ],
        'temperature': 0.3,
        'max_tokens': 2048,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    return _parseVisionResponse(content, imagePath);
  }

  Future<List<Sentence>> _processWithOcrAndLlm(File image) async {
    final base64Image = await _fileToBase64(image);
    final ocrResult = await _performOcr(base64Image);
    return _processTextWithLlm(ocrResult, image.path);
  }

  Future<String> _performOcr(String base64Image) async {
    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': _ocrModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
              },
              {
                'type': 'text',
                'text': '请识别图片中的所有文字，保持原有格式输出。'
              },
            ],
          },
        ],
        'temperature': 0.1,
        'max_tokens': 2048,
      },
    );

    return response.data['choices'][0]['message']['content'] as String;
  }

  Future<List<Sentence>> _processTextWithLlm(String text, String imagePath) async {
    final prompt = '''
请从以下文本中提取中英文句子对，并进行分类：

文本内容：
$text

要求：
1. 提取所有中文句子和对应的英文翻译
2. 对每个句子对进行分类：
   - 场景分类（从以下选择）：日常生活、餐厅用餐、购物消费、旅行出行、工作职场、学校教育、医疗健康、交通出行、住宿酒店、银行金融、邮局快递、电话通讯、天气气候、时间日期、家庭亲情、朋友社交、爱情约会、运动健身、娱乐休闲、音乐艺术、阅读书籍、科技网络、自然环境、动物宠物、节日庆典、新闻媒体、法律政务、面试求职、租房买房、其他场景
   - 时态分类（从以下选择）：一般现在时、一般过去时、一般将来时、现在进行时、过去进行时、将来进行时、现在完成时、过去完成时、将来完成时、现在完成进行时、过去完成进行时、将来完成进行时、过去将来时、过去将来进行时、过去将来完成时、过去将来完成进行时

3. 以JSON格式返回，格式如下：
{
  "sentences": [
    {
      "chinese": "中文句子",
      "english": "English sentence",
      "scene": "场景名称",
      "tense": "时态名称"
    }
  ]
}

如果文本中没有清晰的句子对，请返回空数组。
''';    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': _llmModel,
        'messages': [
          {'role': 'system', 'content': '你是一个专业的语言学习助手，擅长提取和分类中英文句子。'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.3,
        'max_tokens': 2048,
      },
    );

    final content = response.data['choices'][0]['message']['content'] as String;
    return _parseVisionResponse(content, imagePath);
  }

  List<Sentence> _parseVisionResponse(String content, String imagePath) {
    try {
      final jsonStr = _extractJson(content);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final sentences = data['sentences'] as List<dynamic>? ?? [];
      final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.8;

      return sentences.map((item) {
        final map = item as Map<String, dynamic>;
        return Sentence(
          chineseText: map['chinese'] as String,
          englishText: map['english'] as String,
          scene: _normalizeScene(map['scene'] as String),
          tense: _normalizeTense(map['tense'] as String),
          importTime: DateTime.now(),
          imagePath: imagePath,
          ocrConfidence: confidence,
        );
      }).toList();
    } catch (e) {
      print('Failed to parse vision response: $e');
      return [];
    }
  }

  String _extractJson(String content) {
    final codeBlockRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
    final match = codeBlockRegex.firstMatch(content);
    if (match != null) {
      return match.group(1)!;
    }

    final jsonRegex = RegExp(r'\{[\s\S]*\}');
    final jsonMatch = jsonRegex.firstMatch(content);
    if (jsonMatch != null) {
      return jsonMatch.group(0)!;
    }

    return content;
  }

  String _normalizeScene(String scene) {
    final sceneMap = {
      '日常生活': 'daily_life',
      '餐厅用餐': 'restaurant',
      '购物消费': 'shopping',
      '旅行出行': 'travel',
      '工作职场': 'workplace',
      '学校教育': 'education',
      '医疗健康': 'healthcare',
      '交通出行': 'transportation',
      '住宿酒店': 'accommodation',
      '银行金融': 'banking',
      '邮局快递': 'post_office',
      '电话通讯': 'telephone',
      '天气气候': 'weather',
      '时间日期': 'time_date',
      '家庭亲情': 'family',
      '朋友社交': 'friendship',
      '爱情约会': 'romance',
      '运动健身': 'sports',
      '娱乐休闲': 'entertainment',
      '音乐艺术': 'music_art',
      '阅读书籍': 'reading',
      '科技网络': 'technology',
      '自然环境': 'nature',
      '动物宠物': 'animals',
      '节日庆典': 'festivals',
      '新闻媒体': 'news_media',
      '法律政务': 'legal_affairs',
      '面试求职': 'job_interview',
      '租房买房': 'housing',
      '其他场景': 'others',
    };

    return sceneMap[scene] ?? 'others';
  }

  String _normalizeTense(String tense) {
    final tenseMap = {
      '一般现在时': 'simple_present',
      '一般过去时': 'simple_past',
      '一般将来时': 'simple_future',
      '现在进行时': 'present_continuous',
      '过去进行时': 'past_continuous',
      '将来进行时': 'future_continuous',
      '现在完成时': 'present_perfect',
      '过去完成时': 'past_perfect',
      '将来完成时': 'future_perfect',
      '现在完成进行时': 'present_perfect_continuous',
      '过去完成进行时': 'past_perfect_continuous',
      '将来完成进行时': 'future_perfect_continuous',
      '过去将来时': 'past_future',
      '过去将来进行时': 'past_future_continuous',
      '过去将来完成时': 'past_future_perfect',
      '过去将来完成进行时': 'past_future_perfect_continuous',
    };

    return tenseMap[tense] ?? 'simple_present';
  }

  Future<bool> semanticCheck(String userAnswer, String correctAnswer) async {
    final prompt = '''
请判断以下两个英文句子是否在语义上等价：

用户答案：$userAnswer
正确答案：$correctAnswer

要求：
1. 如果用户答案和正确答案表达的意思相同或非常接近，返回 "true"
2. 如果意思有明显差异，返回 "false"
3. 只返回 "true" 或 "false"，不要其他解释

判断结果：
''';    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _llmModel,
          'messages': [
            {'role': 'system', 'content': '你是一个严格的英语句子语义判断助手。'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.1,
          'max_tokens': 10,
        },
      );

      final content = response.data['choices'][0]['message']['content'].toString().toLowerCase().trim();
      return content.contains('true');
    } catch (e) {
      print('Semantic check failed: $e');
      return false;
    }
  }

  Future<AiAnalysisResult> analyzeSentence(String sentence, String userAnswer, bool isCorrect) async {
    final prompt = '''
请对以下英文句子进行详细解析：

句子：$sentence

用户答案：$userAnswer
是否正确：${isCorrect ? '是' : '否'}

请提供以下分析（以JSON格式返回）：
{
  "structure": "句子结构分析，包括主谓宾等成分",
  "tense": "时态类型和用法说明",
  "collocations": ["固定搭配1", "固定搭配2"],
  "similarExpressions": [
    {"english": "相似表达1", "chinese": "中文翻译1"},
    {"english": "相似表达2", "chinese": "中文翻译2"}
  ],
  ${isCorrect ? '' : '"errorAnalysis": "错误原因分析，从表达习惯和欧美文化角度解释",'}
  ${isCorrect ? '' : '"memoryTip": "记忆技巧建议"'}
}
''';    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _llmModel,
          'messages': [
            {'role': 'system', 'content': '你是一个专业的英语教学助手，擅长解析英文句子的结构、时态、固定搭配，并针对中国人学习英语的特点给出建议。'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.5,
          'max_tokens': 2048,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseAnalysisResponse(content, isCorrect);
    } catch (e) {
      print('Sentence analysis failed: $e');
      return AiAnalysisResult(
        structure: '解析失败，请稍后重试',
        tense: '',
        collocations: [],
        similarExpressions: [],
      );
    }
  }

  Future<String> followUpQuestion(int sentenceId, String question, String context) async {
    final prompt = '''
上下文：$context

用户问题：$question

请基于上下文回答用户的问题，提供有帮助的解释。
''';    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _llmModel,
          'messages': [
            {'role': 'system', 'content': '你是一个友好的英语学习助手，回答用户关于英语句子的问题。'},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
        },
      );

      return response.data['choices'][0]['message']['content'] as String;
    } catch (e) {
      print('Follow-up question failed: $e');
      return '抱歉，回答生成失败，请稍后重试。';
    }
  }

  AiAnalysisResult _parseAnalysisResponse(String content, bool isCorrect) {
    try {
      final jsonStr = _extractJson(content);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      final collocations = (data['collocations'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [];

      final similarExpressions = (data['similarExpressions'] as List<dynamic>?)
          ?.map((e) => SimilarExpression(
                english: e['english']?.toString() ?? '',
                chinese: e['chinese']?.toString() ?? '',
              ))
          .toList() ?? [];

      return AiAnalysisResult(
        structure: data['structure']?.toString() ?? '',
        tense: data['tense']?.toString() ?? '',
        collocations: collocations,
        similarExpressions: similarExpressions,
        errorAnalysis: isCorrect ? null : data['errorAnalysis']?.toString(),
        memoryTip: isCorrect ? null : data['memoryTip']?.toString(),
      );
    } catch (e) {
      print('Failed to parse analysis response: $e');
      return AiAnalysisResult(
        structure: content,
        tense: '',
        collocations: [],
        similarExpressions: [],
      );
    }
  }

  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}

class AiAnalysisResult {
  final String structure;
  final String tense;
  final List<String> collocations;
  final List<SimilarExpression> similarExpressions;
  final String? errorAnalysis;
  final String? memoryTip;

  AiAnalysisResult({
    required this.structure,
    required this.tense,
    required this.collocations,
    required this.similarExpressions,
    this.errorAnalysis,
    this.memoryTip,
  });
}

class SimilarExpression {
  final String english;
  final String chinese;

  SimilarExpression({
    required this.english,
    required this.chinese,
  });
}
