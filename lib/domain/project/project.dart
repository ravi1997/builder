import '../collection/collection_experience.dart';
import '../data/data_record.dart';
import '../versioning/artifact_version.dart';
import 'goal.dart';

class Project {
  const Project({
    required this.id,
    required this.name,
    required this.version,
    this.goals = const <Goal>[],
    this.experiences = const <CollectionExperience>[],
    this.dataRecords = const <DataRecord>[],
  });

  final String id;
  final String name;
  final ArtifactVersion version;
  final List<Goal> goals;
  final List<CollectionExperience> experiences;
  final List<DataRecord> dataRecords;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'version': version.toJson(),
        'goals': goals.map((goal) => goal.toJson()).toList(),
        'experiences': experiences.map((experience) => experience.toJson()).toList(),
        'data_records': dataRecords.map((record) => record.toJson()).toList(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        version: ArtifactVersion.fromJson(
          Map<String, dynamic>.from(json['version'] as Map),
        ),
        goals: (json['goals'] as List<dynamic>? ?? const [])
            .map((item) => Goal.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
        experiences: (json['experiences'] as List<dynamic>? ?? const [])
            .map((item) => CollectionExperience.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList(growable: false),
        dataRecords: (json['data_records'] as List<dynamic>? ?? const [])
            .map((item) => DataRecord.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(growable: false),
      );
}
