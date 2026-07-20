import 'data_point_definition.dart';

class DataSource {
  const DataSource({required this.type, required this.id});

  final DataSourceType type;
  final String id;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type.name,
        'id': id,
      };

  factory DataSource.fromJson(Map<String, dynamic> json) => DataSource(
        type: DataSourceType.values.byName(json['type'] as String),
        id: json['id'] as String,
      );
}

class DataPoint {
  const DataPoint({
    required this.id,
    required this.definitionId,
    required this.value,
    required this.source,
    required this.observedAt,
    this.confidence,
  });

  final String id;
  final String definitionId;
  final dynamic value;
  final DataSource source;
  final DateTime observedAt;
  final double? confidence;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'definition_id': definitionId,
        'value': value,
        'source': source.toJson(),
        'observed_at': observedAt.toIso8601String(),
        'confidence': confidence,
      };

  factory DataPoint.fromJson(Map<String, dynamic> json) => DataPoint(
        id: json['id'] as String,
        definitionId: json['definition_id'] as String,
        value: json['value'],
        source: DataSource.fromJson(Map<String, dynamic>.from(json['source'] as Map)),
        observedAt: DateTime.parse(json['observed_at'] as String),
        confidence: (json['confidence'] as num?)?.toDouble(),
      );
}
