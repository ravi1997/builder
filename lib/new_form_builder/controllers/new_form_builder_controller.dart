import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/form_models.dart';
import '../validators/form_validator.dart';
import '../workflow/workflow_engine.dart';

class NewFormBuilderState {
  const NewFormBuilderState({
    required this.definition,
    required this.selectedFieldId,
    required this.previewMode,
    required this.values,
    required this.history,
    required this.validationErrors,
  });

  factory NewFormBuilderState.initial() => const NewFormBuilderState(
        definition: FormDefinition(
          id: 'new-form-1',
          title: 'New Form',
          sections: [
            FormSectionModel(
              id: 'section-1',
              title: 'Section 1',
              fields: [
                FormFieldModel(id: 'field-1', type: FormFieldType.text, label: 'First name', required: true),
                FormFieldModel(id: 'field-2', type: FormFieldType.text, label: 'Last name'),
              ],
            ),
          ],
        ),
        selectedFieldId: null,
        previewMode: false,
        values: {},
        history: [],
        validationErrors: {},
      );

  final FormDefinition definition;
  final String? selectedFieldId;
  final bool previewMode;
  final Map<String, Object?> values;
  final List<AuditEntry> history;
  final Map<String, String> validationErrors;

  NewFormBuilderState copyWith({
    FormDefinition? definition,
    String? selectedFieldId,
    bool? previewMode,
    Map<String, Object?>? values,
    List<AuditEntry>? history,
    Map<String, String>? validationErrors,
    bool clearSelection = false,
  }) {
    return NewFormBuilderState(
      definition: definition ?? this.definition,
      selectedFieldId: clearSelection ? null : selectedFieldId ?? this.selectedFieldId,
      previewMode: previewMode ?? this.previewMode,
      values: values ?? this.values,
      history: history ?? this.history,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}

class NewFormBuilderController extends StateNotifier<NewFormBuilderState> {
  NewFormBuilderController()
      : _validator = const FormValidator(),
        _workflowEngine = const WorkflowEngine(),
        super(NewFormBuilderState.initial());

  final FormValidator _validator;
  final WorkflowEngine _workflowEngine;

  void selectField(String? id) => state = state.copyWith(selectedFieldId: id, clearSelection: id == null);

  void togglePreview() => state = state.copyWith(previewMode: !state.previewMode);

  void updateFieldValue(String fieldId, Object? value) {
    final next = Map<String, Object?>.from(state.values)..[fieldId] = value;
    state = state.copyWith(values: next);
  }

  void addFieldType(FormFieldType type) {
    final base = state.definition;
    final updatedSections = [...base.sections];
    if (updatedSections.isEmpty) {
      updatedSections.add(
        FormSectionModel(
          id: 'section-1',
          title: 'Section 1',
          fields: [
            FormFieldModel(
              id: 'field-${DateTime.now().microsecondsSinceEpoch}',
              type: type,
              label: '${type.name} field',
            ),
          ],
        ),
      );
    } else {
      final last = updatedSections.removeLast();
      updatedSections.add(
        FormSectionModel(
          id: last.id,
          title: last.title,
          description: last.description,
          order: last.order,
          visibilityRules: last.visibilityRules,
          fields: [
            ...last.fields,
            FormFieldModel(
              id: 'field-${DateTime.now().microsecondsSinceEpoch}',
              type: type,
              label: '${type.name} field',
            ),
          ],
        ),
      );
    }
    state = state.copyWith(
      definition: FormDefinition(
        id: base.id,
        title: base.title,
        description: base.description,
        instructions: base.instructions,
        sections: updatedSections,
        workflow: base.workflow,
        accessPolicy: base.accessPolicy,
        version: base.version,
        theme: base.theme,
        layout: base.layout,
        analytics: base.analytics,
      ),
    );
  }

  void validate() {
    final result = _validator.validateSubmission(definition: state.definition, values: state.values);
    state = state.copyWith(validationErrors: result.errors);
  }

  void advanceWorkflow() {
    final workflow = state.definition.workflow;
    final next = _workflowEngine.next(workflow.status);
    state = state.copyWith(
      definition: FormDefinition(
        id: state.definition.id,
        title: state.definition.title,
        description: state.definition.description,
        instructions: state.definition.instructions,
        sections: state.definition.sections,
        workflow: WorkflowDefinition(status: next, steps: workflow.steps),
        accessPolicy: state.definition.accessPolicy,
        version: state.definition.version,
        theme: state.definition.theme,
        layout: state.definition.layout,
        analytics: state.definition.analytics,
      ),
    );
  }
}
