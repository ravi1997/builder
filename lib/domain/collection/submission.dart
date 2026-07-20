import 'answer.dart';

class Submission {
  const Submission({
    required this.id,
    required this.experienceId,
    required this.experienceVersionId,
    required this.submittedAt,
    this.respondentMetadata = const <String, dynamic>{},
    this.answers = const <Answer>[],
  });

  final String id;
  final String experienceId;
  final String experienceVersionId;
  final DateTime submittedAt;
  final Map<String, dynamic> respondentMetadata;
  final List<Answer> answers;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'experience_id': experienceId,
        'experience_version_id': experienceVersionId,
        'submitted_at': submittedAt.toIso8601String(),
        'respondent_metadata': respondentMetadata,
        'answers': answers.map((answer) => answer.toJson()).toList(),
      };

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
        id: json['id'] as String,
        experienceId: json['experience_id'] as String,
        experienceVersionId: json['experience_version_id'] as String,
        submittedAt: DateTime.parse(json['submitted_at'] as String),
        respondentMetadata: Map<String, dynamic>.from(
          json['respondent_metadata'] as Map<String, dynamic>? ?? const {},
        ),
        answers: (json['answers'] as List<dynamic>? ?? const [])
            .map((item) => Answer.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
      );
}
