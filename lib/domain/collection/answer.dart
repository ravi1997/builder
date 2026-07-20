class Answer {
  const Answer({
    required this.id,
    required this.questionId,
    required this.value,
    required this.capturedAt,
  });

  final String id;
  final String questionId;
  final dynamic value;
  final DateTime capturedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'question_id': questionId,
        'value': value,
        'captured_at': capturedAt.toIso8601String(),
      };

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as String,
        questionId: json['question_id'] as String,
        value: json['value'],
        capturedAt: DateTime.parse(json['captured_at'] as String),
      );
}
