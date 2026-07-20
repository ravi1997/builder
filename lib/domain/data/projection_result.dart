enum ProjectionResultStatus { projected, rejected, failed }

class ProjectionResult {
  const ProjectionResult({
    required this.id,
    required this.submissionId,
    required this.answerId,
    required this.questionId,
    required this.projectionRuleVersion,
    required this.status,
    required this.createdAt,
    this.dataPointId,
    this.rejectionCode,
    this.rejectionReason,
  });

  final String id;
  final String submissionId;
  final String answerId;
  final String questionId;
  final String projectionRuleVersion;
  final ProjectionResultStatus status;
  final DateTime createdAt;
  final String? dataPointId;
  final String? rejectionCode;
  final String? rejectionReason;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'submission_id': submissionId,
        'answer_id': answerId,
        'question_id': questionId,
        'projection_rule_version': projectionRuleVersion,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'data_point_id': dataPointId,
        'rejection_code': rejectionCode,
        'rejection_reason': rejectionReason,
      };

  factory ProjectionResult.fromJson(Map<String, dynamic> json) => ProjectionResult(
        id: json['id'] as String,
        submissionId: json['submission_id'] as String,
        answerId: json['answer_id'] as String,
        questionId: json['question_id'] as String,
        projectionRuleVersion: json['projection_rule_version'] as String,
        status: ProjectionResultStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
        dataPointId: json['data_point_id'] as String?,
        rejectionCode: json['rejection_code'] as String?,
        rejectionReason: json['rejection_reason'] as String?,
      );
}
