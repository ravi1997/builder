import 'package:flutter_test/flutter_test.dart';

import 'package:builder/new_form_builder/models/form_models.dart';
import 'package:builder/new_form_builder/validators/form_validator.dart';

void main() {
  test('FormDefinition round-trips to JSON', () {
    const definition = FormDefinition(
      id: 'form-1',
      title: 'Demo Form',
      sections: [
        FormSectionModel(
          id: 'section-1',
          title: 'Section 1',
          fields: [
            FormFieldModel(id: 'field-1', type: FormFieldType.text, label: 'Name', required: true),
          ],
        ),
      ],
      workflow: WorkflowDefinition(status: WorkflowStatus.draft),
      accessPolicy: AccessPolicy(roles: ['admin'], maskSensitiveFields: true),
      version: 3,
    );

    final json = definition.toJson();
    final restored = FormDefinition.fromJson(json);

    expect(restored.id, definition.id);
    expect(restored.title, definition.title);
    expect(restored.sections, hasLength(1));
    expect(restored.sections.first.fields.first.label, 'Name');
    expect(restored.accessPolicy.maskSensitiveFields, isTrue);
    expect(restored.version, 3);
  });

  test('FormValidator flags missing required labels and duplicate ids', () {
    const definition = FormDefinition(
      id: 'form-2',
      title: 'Broken',
      sections: [
        FormSectionModel(
          id: 'section-1',
          title: 'Section 1',
          fields: [
            FormFieldModel(id: 'field-1', type: FormFieldType.text, label: '', required: true),
            FormFieldModel(id: 'field-1', type: FormFieldType.text, label: 'Duplicate'),
          ],
        ),
      ],
    );

    final result = const FormValidator().validateDefinition(definition);

    expect(result.isValid, isFalse);
    expect(result.errors, containsPair('field:field-1:label', 'Required fields need a label'));
  });
}
