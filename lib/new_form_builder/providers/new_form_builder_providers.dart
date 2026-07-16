import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/new_form_builder_controller.dart';
import '../models/form_models.dart';

final newFormBuilderProvider =
    StateNotifierProvider<NewFormBuilderController, NewFormBuilderState>(
  (ref) => NewFormBuilderController(),
);

final newFormDefinitionProvider = Provider<FormDefinition>((ref) {
  return ref.watch(newFormBuilderProvider).definition;
});

final newCanvasProvider = Provider<List<FormSectionModel>>((ref) {
  return ref.watch(newFormDefinitionProvider).sections;
});

final newSelectionProvider = Provider<String?>((ref) {
  return ref.watch(newFormBuilderProvider).selectedFieldId;
});

final newHistoryProvider = Provider<List<AuditEntry>>((ref) {
  return ref.watch(newFormBuilderProvider).history;
});

final newWorkflowProvider = Provider<WorkflowDefinition>((ref) {
  return ref.watch(newFormDefinitionProvider).workflow;
});
