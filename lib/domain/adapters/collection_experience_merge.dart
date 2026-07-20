import '../collection/collection_experience.dart';

/// Combines a structure-only [CollectionExperience] (from
/// [LegacyStructureAdapter]) and a presentation-only one (from
/// [DesignPresentationAdapter]) into a single aggregate, since both editors
/// write different slices of the same experience id (section 4/11).
///
/// `left` wins on `id`/`type`/`version`; callers should pass whichever side
/// currently owns versioning (typically the structure editor).
CollectionExperience mergeCollectionExperiences(
  CollectionExperience left,
  CollectionExperience right,
) {
  return CollectionExperience(
    id: left.id,
    type: left.type,
    version: left.version,
    schema: left.schema.isNotEmpty ? left.schema : right.schema,
    presentation: right.presentation.isNotEmpty ? right.presentation : left.presentation,
    validation: left.validation.isNotEmpty ? left.validation : right.validation,
    sourceMappings:
        left.sourceMappings.isNotEmpty ? left.sourceMappings : right.sourceMappings,
  );
}
