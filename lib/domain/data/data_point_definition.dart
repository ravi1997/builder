enum DataType { text, number, boolean, date, datetime, json }

enum DataSourceType { form, api, import, integration, ai }

class DataPointDefinition {
  const DataPointDefinition({
    required this.id,
    required this.conceptId,
    required this.name,
    required this.type,
    this.allowedSources = const <DataSourceType>[],
  });

  final String id;
  final String conceptId;
  final String name;
  final DataType type;
  final List<DataSourceType> allowedSources;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'concept_id': conceptId,
        'name': name,
        'type': type.name,
        'allowed_sources': allowedSources.map((source) => source.name).toList(),
      };

  factory DataPointDefinition.fromJson(Map<String, dynamic> json) =>
      DataPointDefinition(
        id: json['id'] as String,
        conceptId: json['concept_id'] as String,
        name: json['name'] as String,
        type: DataType.values.byName(json['type'] as String),
        allowedSources: (json['allowed_sources'] as List<dynamic>? ?? const [])
            .map((source) => DataSourceType.values.byName(source as String))
            .toList(growable: false),
      );
}
