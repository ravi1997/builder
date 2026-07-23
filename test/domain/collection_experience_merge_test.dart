import 'package:builder/domain/adapters/adapters.dart';
import 'package:builder/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('merges structure-only and presentation-only experiences', () {
    final structureOnly = CollectionExperience(
      id: 'experience-1',
      type: CollectionExperienceType.form,
      version: ArtifactVersion(id: 'experience-1_v1'),
      schema: const {
        'sections': [
          {'id': 'section-1', 'title': 'Contact info', 'elements': []},
        ],
      },
    );
    final presentationOnly = CollectionExperience(
      id: 'experience-1',
      type: CollectionExperienceType.form,
      version: ArtifactVersion(id: 'experience-1_v1'),
      presentation: const {
        'layout': {'layout_type': 'wizardSection'},
      },
    );

    final merged = mergeCollectionExperiences(structureOnly, presentationOnly);

    expect(merged.schema, structureOnly.schema);
    expect(merged.presentation, presentationOnly.presentation);
    expect(merged.id, 'experience-1');
  });
}
