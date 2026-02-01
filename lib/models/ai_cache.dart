class AiCache {
  final int? id;
  final int sentenceId;
  final String cacheType;
  final String content;
  final DateTime createdAt;
  final bool isExpired;

  AiCache({
    this.id,
    required this.sentenceId,
    required this.cacheType,
    required this.content,
    required this.createdAt,
    this.isExpired = false,
  });

  static const String typeBasic = 'basic';
  static const String typeFollowUp = 'follow_up';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sentence_id': sentenceId,
      'cache_type': cacheType,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_expired': isExpired ? 1 : 0,
    };
  }

  factory AiCache.fromMap(Map<String, dynamic> map) {
    return AiCache(
      id: map['id'] as int?,
      sentenceId: map['sentence_id'] as int,
      cacheType: map['cache_type'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      isExpired: (map['is_expired'] as int? ?? 0) == 1,
    );
  }

  AiCache copyWith({
    int? id,
    int? sentenceId,
    String? cacheType,
    String? content,
    DateTime? createdAt,
    bool? isExpired,
  }) {
    return AiCache(
      id: id ?? this.id,
      sentenceId: sentenceId ?? this.sentenceId,
      cacheType: cacheType ?? this.cacheType,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  bool get isExpiredByTime {
    if (cacheType == typeBasic) return false;
    final expiryDate = createdAt.add(const Duration(days: 7));
    return DateTime.now().isAfter(expiryDate);
  }
}
