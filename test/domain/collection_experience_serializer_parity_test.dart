import 'package:builder/domain/adapters/adapters.dart';
import 'package:builder/domain/domain.dart';
import 'package:builder/domain/serialization/collection_experience_serializer.dart';
import 'package:builder/models/form_element.dart';
import 'package:builder/models/form_section.dart';
import 'package:builder/utils/backend_payload_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stage 3 gate: the new domain-aggregate serializer must produce payloads
/// byte-for-byte equivalent to the legacy BackendPayloadBuilder before the
/// legacy builder can be retired (Domain Specification v0.1 section 12).
void main() {
  final sections = [
    FormSection(
      id: 'section-nested-0001',
      title: 'Section 1',
      elements: [
        FormElement(
          id: 'question-nested-0001',
          type: 'text',
          label: 'Question',
          required: false,
          properties: const {
            'placeholder': null,
            'description': null,
            'defaultValue': null,
            'validationConditions': <dynamic>[],
            'validationConditionMessages': <String, dynamic>{},
            'options': <dynamic>[],
          },
        ),
        FormElement(
          id: 'question-nested-0002',
          type: 'dropdown',
          label: 'Country',
          required: true,
          properties: const {
            'placeholder': 'Pick one',
            'description': 'Country of residence',
            'defaultValue': 'US',
            'validationConditions': ['required'],
            'validationConditionMessages': {
              'required': 'This field is required',
            },
            'options': ['US', 'IN', 'UK'],
          },
        ),
      ],
    ),
  ];

  test(
    'version serializer matches BackendPayloadBuilder.buildVersionPayload',
    () {
      final legacy = BackendPayloadBuilder.buildVersionPayload(
        versionUuid: 'entity-v2',
      );
      final domain = CollectionExperienceSerializer.version(
        ArtifactVersion(id: 'entity-v2'),
      );
      expect(domain, legacy);
    },
  );

  test(
    'version serializer matches legacy for a non-default status/createdBy',
    () {
      final legacy = BackendPayloadBuilder.buildVersionPayload(
        versionUuid: 'entity-v3',
        major: 2,
        minor: 1,
        patch: 4,
        status: 'approved',
        createdBy: 'ravi',
      );
      final domain = CollectionExperienceSerializer.version(
        ArtifactVersion(
          id: 'entity-v3',
          major: 2,
          minor: 1,
          patch: 4,
          status: ArtifactVersionStatus.approved,
          createdBy: 'ravi',
        ),
      );
      expect(domain, legacy);
    },
  );

  test(
    'project serializer matches BackendPayloadBuilder.buildProjectPayload',
    () {
      final legacy = BackendPayloadBuilder.buildProjectPayload();
      final domain = CollectionExperienceSerializer.project(
        Project(
          id: 'project-crud-0001',
          name: 'Project CRUD',
          version: ArtifactVersion(id: 'project-v1'),
        ),
      );
      expect(domain, legacy);
    },
  );

  test(
    'project serializer forces nested version status to draft like legacy',
    () {
      final domain = CollectionExperienceSerializer.project(
        Project(
          id: 'project-crud-0001',
          name: 'Project CRUD',
          version: ArtifactVersion(
            id: 'project-v1',
            status: ArtifactVersionStatus.published,
          ),
        ),
      );
      expect(
        (domain['versions'] as List<dynamic>).first,
        containsPair('status', 'draft'),
      );
    },
  );

  test(
    'form serializer matches BackendPayloadBuilder.buildFormPayload for nested sections/questions',
    () {
      final legacy = BackendPayloadBuilder.buildFormPayload(
        projectUuid: 'project-crud-0001',
        formUuid: 'form-crud-0001',
        formVersionUuid: 'form-v1',
        sections: sections,
      );

      final experience = LegacyStructureAdapter.toCollectionExperience(
        id: 'form-crud-0001',
        sections: sections,
        version: ArtifactVersion(id: 'form-v1'),
      );
      final domain = CollectionExperienceSerializer.form(experience);

      expect(domain, legacy);
    },
  );

  test('section serializer matches legacy nested section shape', () {
    final legacyForm = BackendPayloadBuilder.buildFormPayload(
      projectUuid: 'project-crud-0001',
      formUuid: 'form-crud-0001',
      formVersionUuid: 'form-v1',
      sections: sections,
    );
    final legacySections =
        (legacyForm['sections'] as Map<String, dynamic>)['form-v1']
            as List<dynamic>;

    final domain = CollectionExperienceSerializer.section(sections.first);

    expect(domain, legacySections.first);
  });

  test('question serializer matches legacy nested question shape', () {
    final legacyForm = BackendPayloadBuilder.buildFormPayload(
      projectUuid: 'project-crud-0001',
      formUuid: 'form-crud-0001',
      formVersionUuid: 'form-v1',
      sections: sections,
    );
    final legacyQuestions =
        ((legacyForm['sections'] as Map<String, dynamic>)['form-v1']
                    as List<dynamic>)
                .first['questions']
            as Map<String, dynamic>;
    final legacyQuestion =
        (legacyQuestions['section-nested-0001_v1'] as List<dynamic>)[1]
            as Map<String, dynamic>;

    final domain = CollectionExperienceSerializer.question(
      sections.first.elements[1],
    );

    expect(domain, legacyQuestion);
  });
}
