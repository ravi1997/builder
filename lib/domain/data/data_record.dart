import 'data_point.dart';

class DataRecord {
  const DataRecord({
    required this.id,
    required this.projectId,
    this.entityType,
    this.externalId,
    this.dataPoints = const <DataPoint>[],
  });

  final String id;
  final String projectId;
  final String? entityType;
  final String? externalId;
  final List<DataPoint> dataPoints;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'project_id': projectId,
        'entity_type': entityType,
        'external_id': externalId,
        'data_points': dataPoints.map((point) => point.toJson()).toList(),
      };

  factory DataRecord.fromJson(Map<String, dynamic> json) => DataRecord(
        id: json['id'] as String,
        projectId: json['project_id'] as String,
        entityType: json['entity_type'] as String?,
        externalId: json['external_id'] as String?,
        dataPoints: (json['data_points'] as List<dynamic>? ?? const [])
            .map((item) => DataPoint.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
      );
}
