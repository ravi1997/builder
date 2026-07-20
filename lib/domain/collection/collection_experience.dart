import '../versioning/artifact_version.dart';

enum CollectionExperienceType { form, survey, assessment, import, api, integration }

class CollectionExperience {
  const CollectionExperience({
    required this.id,
    required this.type,
    required this.version,
    this.schema = const <String, dynamic>{},
    this.presentation = const <String, dynamic>{},
    this.validation = const <String, dynamic>{},
    this.sourceMappings = const <String, dynamic>{},
  });

  final String id;
  final CollectionExperienceType type;
  final ArtifactVersion version;
  final Map<String, dynamic> schema;
  final Map<String, dynamic> presentation;
  final Map<String, dynamic> validation;
  final Map<String, dynamic> sourceMappings;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'version': version.toJson(),
        'schema': schema,
        'presentation': presentation,
        'validation': validation,
        'source_mappings': sourceMappings,
      };

  factory CollectionExperience.fromJson(Map<String, dynamic> json) =>
      CollectionExperience(
        id: json['id'] as String,
        type: CollectionExperienceType.values.byName(json['type'] as String),
        version: ArtifactVersion.fromJson(
          Map<String, dynamic>.from(json['version'] as Map),
        ),
        schema: Map<String, dynamic>.from(json['schema'] as Map? ?? const {}),
        presentation: Map<String, dynamic>.from(
          json['presentation'] as Map? ?? const {},
        ),
        validation: Map<String, dynamic>.from(
          json['validation'] as Map? ?? const {},
        ),
        sourceMappings: Map<String, dynamic>.from(
          json['source_mappings'] as Map? ?? const {},
        ),
      );
}
