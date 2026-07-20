import 'package:builder/domain/adapters/adapters.dart';
import 'package:builder/models/form_element.dart';
import 'package:builder/models/form_section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy sections round-trip through a CollectionExperience', () {
    final sections = [
      FormSection(
        id: 'section-1',
        title: 'Contact info',
        elements: [
          FormElement(
            id: 'field-1',
            type: 'text',
            label: 'Full name',
            required: true,
            properties: const {'placeholder': 'Jane Doe'},
          ),
          FormElement(
            id: 'field-2',
            type: 'dropdown',
            label: 'Country',
            required: false,
            properties: const {
              'options': ['US', 'IN', 'UK'],
            },
          ),
        ],
      ),
    ];

    final experience = LegacyStructureAdapter.toCollectionExperience(
      id: 'experience-1',
      sections: sections,
    );

    expect(experience.type.name, 'form');
    expect(experience.schema['sections'], isA<List<dynamic>>());

    final restored = LegacyStructureAdapter.sectionsFromExperience(experience);

    expect(restored, hasLength(1));
    expect(restored.first.id, 'section-1');
    expect(restored.first.title, 'Contact info');
    expect(restored.first.elements, hasLength(2));
    expect(restored.first.elements[0].label, 'Full name');
    expect(restored.first.elements[0].required, isTrue);
    expect(restored.first.elements[0].properties['placeholder'], 'Jane Doe');
    expect(restored.first.elements[1].properties['options'], ['US', 'IN', 'UK']);
  });

  test('sectionsFromSchema tolerates an empty schema', () {
    expect(LegacyStructureAdapter.sectionsFromSchema(const {}), isEmpty);
  });
}
