class Sentence {
  final int? id;
  final String chineseText;
  final String englishText;
  final String scene;
  final String tense;
  final DateTime importTime;
  final DateTime? sourceTime;
  final String? imagePath;
  final double? ocrConfidence;
  final int retryCount;
  final int reviewCount;
  final int hintCount;
  final int errorCount;
  final DateTime? lastReviewTime;
  final bool isMastered;

  Sentence({
    this.id,
    required this.chineseText,
    required this.englishText,
    required this.scene,
    required this.tense,
    required this.importTime,
    this.sourceTime,
    this.imagePath,
    this.ocrConfidence,
    this.retryCount = 0,
    this.reviewCount = 0,
    this.hintCount = 0,
    this.errorCount = 0,
    this.lastReviewTime,
    this.isMastered = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chinese_text': chineseText,
      'english_text': englishText,
      'scene': scene,
      'tense': tense,
      'import_time': importTime.toIso8601String(),
      'source_time': sourceTime?.toIso8601String(),
      'image_path': imagePath,
      'ocr_confidence': ocrConfidence,
      'retry_count': retryCount,
      'review_count': reviewCount,
      'hint_count': hintCount,
      'error_count': errorCount,
      'last_review_time': lastReviewTime?.toIso8601String(),
      'is_mastered': isMastered ? 1 : 0,
    };
  }

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['id'] as int?,
      chineseText: map['chinese_text'] as String,
      englishText: map['english_text'] as String,
      scene: map['scene'] as String,
      tense: map['tense'] as String,
      importTime: DateTime.parse(map['import_time'] as String),
      sourceTime: map['source_time'] != null
          ? DateTime.parse(map['source_time'] as String)
          : null,
      imagePath: map['image_path'] as String?,
      ocrConfidence: map['ocr_confidence'] as double?,
      retryCount: map['retry_count'] as int? ?? 0,
      reviewCount: map['review_count'] as int? ?? 0,
      hintCount: map['hint_count'] as int? ?? 0,
      errorCount: map['error_count'] as int? ?? 0,
      lastReviewTime: map['last_review_time'] != null
          ? DateTime.parse(map['last_review_time'] as String)
          : null,
      isMastered: (map['is_mastered'] as int? ?? 0) == 1,
    );
  }

  Sentence copyWith({
    int? id,
    String? chineseText,
    String? englishText,
    String? scene,
    String? tense,
    DateTime? importTime,
    DateTime? sourceTime,
    String? imagePath,
    double? ocrConfidence,
    int? retryCount,
    int? reviewCount,
    int? hintCount,
    int? errorCount,
    DateTime? lastReviewTime,
    bool? isMastered,
  }) {
    return Sentence(
      id: id ?? this.id,
      chineseText: chineseText ?? this.chineseText,
      englishText: englishText ?? this.englishText,
      scene: scene ?? this.scene,
      tense: tense ?? this.tense,
      importTime: importTime ?? this.importTime,
      sourceTime: sourceTime ?? this.sourceTime,
      imagePath: imagePath ?? this.imagePath,
      ocrConfidence: ocrConfidence ?? this.ocrConfidence,
      retryCount: retryCount ?? this.retryCount,
      reviewCount: reviewCount ?? this.reviewCount,
      hintCount: hintCount ?? this.hintCount,
      errorCount: errorCount ?? this.errorCount,
      lastReviewTime: lastReviewTime ?? this.lastReviewTime,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  @override
  String toString() {
    return 'Sentence(id: $id, chinese: $chineseText, english: $englishText, scene: $scene, tense: $tense)';
  }
}
