import '../../models/form_section.dart';
import '../collection/collection_experience.dart';
import '../versioning/artifact_version.dart';

/// Maps the legacy structure editor (`lib/providers/form_builder_provider.dart`,
/// `lib/models/form_section.dart`, `lib/models/form_element.dart`) onto the
/// `schema` slice of a [CollectionExperience], per Domain Specification v0.1
/// section 4 and section 11.
///
/// This adapter only produces/reads domain data; it does not touch provider
/// state or the save/export boundary, which remains on
/// `BackendPayloadBuilder` until Stage 3.
class LegacyStructureAdapter {
  const LegacyStructureAdapter._();

  static Map<String, dynamic> schemaFromSections(List<FormSection> sections) =>
      <String, dynamic>{
        'sections': sections.map((section) => section.toJson()).toList(),
      };

  static List<FormSection> sectionsFromSchema(Map<String, dynamic> schema) {
    final rawSections = schema['sections'] as List<dynamic>? ?? const [];
    return rawSections
        .map(
          (item) =>
              FormSection.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false);
  }

  /// Builds a [CollectionExperience] of type `form` from legacy structure
  /// editor state. `presentation`/`validation`/`sourceMappings` are left to
  /// the design builder adapter and the future condition adapter (section 5)
  /// so this adapter stays scoped to structure only.
  static CollectionExperience toCollectionExperience({
    required String id,
    required List<FormSection> sections,
    ArtifactVersion? version,
    Map<String, dynamic> presentation = const <String, dynamic>{},
    Map<String, dynamic> validation = const <String, dynamic>{},
    Map<String, dynamic> sourceMappings = const <String, dynamic>{},
  }) {
    return CollectionExperience(
      id: id,
      type: CollectionExperienceType.form,
      version: version ?? ArtifactVersion(id: '${id}_v1'),
      schema: schemaFromSections(sections),
      presentation: presentation,
      validation: validation,
      sourceMappings: sourceMappings,
    );
  }

  /// Reconstructs legacy structure editor state (section list) from a
  /// [CollectionExperience]'s schema, e.g. to load an existing experience
  /// back into the structure editor.
  static List<FormSection> sectionsFromExperience(
    CollectionExperience experience,
  ) => sectionsFromSchema(experience.schema);
}
