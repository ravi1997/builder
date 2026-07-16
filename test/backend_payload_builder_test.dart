import 'package:builder/models/form_element.dart';
import 'package:builder/models/form_section.dart';
import 'package:builder/providers/form_builder_provider.dart';
import 'package:builder/utils/backend_payload_builder.dart';
import 'package:builder/widgets/toolbar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildCurrentSavePreview returns a stable backend-shaped payload', () {
    final payload = BackendPayloadBuilder.buildCurrentSavePreview(
      sections: [
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
          ],
        ),
      ],
    );

    expect(payload['uuid'], 'form-crud-0001');
    expect(payload['status'], 'active');
    expect(payload['is_public'], false);
    expect(payload['sections'], isA<Map<String, dynamic>>());

    final sections = payload['sections'] as Map<String, dynamic>;
    final formSections = sections['form-v1'] as List<dynamic>;
    expect(formSections, hasLength(1));

    final section = formSections.first as Map<String, dynamic>;
    expect(section['uuid'], 'section-nested-0001');
    expect(section['title'], 'Section 1');
    expect(section['add_button'], true);

    final questions = section['questions'] as Map<String, dynamic>;
    final sectionQuestions = questions['section-nested-0001_v1'] as List<dynamic>;
    expect(sectionQuestions, hasLength(1));

    final question = sectionQuestions.first as Map<String, dynamic>;
    expect(question['uuid'], 'question-nested-0001');
    expect(question['type'], 'text');
    expect(question['label'], 'Question');
    expect(question['placeholder'], isNull);
    expect(question['choices'], isEmpty);
  });

  test('buildProjectPayload returns backend defaults', () {
    final payload = BackendPayloadBuilder.buildProjectPayload();

    expect(payload, containsPair('uuid', 'project-crud-0001'));
    expect(payload, containsPair('name', 'Project CRUD'));
    expect(payload, containsPair('status', 'active'));
    expect(payload['versions'], isA<List<dynamic>>());
    expect((payload['versions'] as List<dynamic>).first, containsPair('uuid', 'project-v1'));
  });

  test('buildVersionPayload returns backend version shape', () {
    final payload = BackendPayloadBuilder.buildVersionPayload(versionUuid: 'entity-v2');

    expect(payload, {
      'uuid': 'entity-v2',
      'major': 1,
      'minor': 0,
      'patch': 0,
      'status': 'draft',
      'created_by': null,
    });
  });

  test('buildQuestionPayload preserves nulls and empty collections', () {
    final payload = BackendPayloadBuilder.buildQuestionPayload(
      choices: const [],
      validationConditions: const [],
      validationConditionMessages: const {},
    );

    expect(payload['placeholder'], isNull);
    expect(payload['description'], isNull);
    expect(payload['choices'], isEmpty);
    expect(payload['validation_conditions'], isEmpty);
    expect(payload['validation_condition_messages'], isEmpty);
    expect(payload['status'], 'active');
  });

  test('FormBuilderNotifier switches save preview by variant', () {
    final notifier = FormBuilderNotifier();

    expect(notifier.buildBackendSavePreview(variant: SavePayloadVariant.project)['uuid'], 'project-crud-0001');
    expect(notifier.buildBackendSavePreview(variant: SavePayloadVariant.form)['uuid'], 'form-crud-0001');
    expect(notifier.buildBackendSavePreview(variant: SavePayloadVariant.section)['uuid'], isNotNull);
    expect(notifier.buildBackendSavePreview(variant: SavePayloadVariant.question)['uuid'], isNotNull);
    expect(notifier.buildBackendSavePreview(variant: SavePayloadVariant.version)['uuid'], 'entity-v2');
  });
}
