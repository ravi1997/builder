enum ArtifactVersionStatus {
  draft,
  review,
  approved,
  published,
  deprecated,
  archived,
}

class ArtifactVersion {
  const ArtifactVersion({
    required this.id,
    this.major = 1,
    this.minor = 0,
    this.patch = 0,
    this.status = ArtifactVersionStatus.draft,
    this.createdBy,
    this.createdAt,
    this.approvedBy,
    this.approvedAt,
    this.parentVersionId,
    this.dependencyVersionIds = const <String>[],
    this.changelog,
  });

  final String id;
  final int major;
  final int minor;
  final int patch;
  final ArtifactVersionStatus status;
  final String? createdBy;
  final DateTime? createdAt;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? parentVersionId;
  final List<String> dependencyVersionIds;
  final String? changelog;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'major': major,
        'minor': minor,
        'patch': patch,
        'status': status.name,
        'created_by': createdBy,
        'created_at': createdAt?.toIso8601String(),
        'approved_by': approvedBy,
        'approved_at': approvedAt?.toIso8601String(),
        'parent_version_id': parentVersionId,
        'dependency_version_ids': dependencyVersionIds,
        'changelog': changelog,
      };

  factory ArtifactVersion.fromJson(Map<String, dynamic> json) => ArtifactVersion(
        id: json['id'] as String,
        major: json['major'] as int? ?? 1,
        minor: json['minor'] as int? ?? 0,
        patch: json['patch'] as int? ?? 0,
        status: ArtifactVersionStatus.values.byName(
          json['status'] as String? ?? ArtifactVersionStatus.draft.name,
        ),
        createdBy: json['created_by'] as String?,
        createdAt: _date(json['created_at']),
        approvedBy: json['approved_by'] as String?,
        approvedAt: _date(json['approved_at']),
        parentVersionId: json['parent_version_id'] as String?,
        dependencyVersionIds: List<String>.from(
          json['dependency_version_ids'] as List<dynamic>? ?? const <dynamic>[],
        ),
        changelog: json['changelog'] as String?,
      );
}

DateTime? _date(Object? value) =>
    value == null ? null : DateTime.parse(value as String);
