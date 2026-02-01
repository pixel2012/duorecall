class ConversationHistory {
  final int? id;
  final int sentenceId;
  final String question;
  final String answer;
  final DateTime createdAt;

  ConversationHistory({
    this.id,
    required this.sentenceId,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sentence_id': sentenceId,
      'question': question,
      'answer': answer,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ConversationHistory.fromMap(Map<String, dynamic> map) {
    return ConversationHistory(
      id: map['id'] as int?,
      sentenceId: map['sentence_id'] as int,
      question: map['question'] as String,
      answer: map['answer'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  ConversationHistory copyWith({
    int? id,
    int? sentenceId,
    String? question,
    String? answer,
    DateTime? createdAt,
  }) {
    return ConversationHistory(
      id: id ?? this.id,
      sentenceId: sentenceId ?? this.sentenceId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
