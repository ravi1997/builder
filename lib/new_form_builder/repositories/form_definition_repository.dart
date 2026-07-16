import '../models/form_models.dart';

abstract class FormDefinitionRepository {
  Future<FormDefinition?> loadDraft();
  Future<void> saveDraft(FormDefinition definition);
  Future<void> publish(FormDefinition definition);
}

class InMemoryFormDefinitionRepository implements FormDefinitionRepository {
  FormDefinition? _draft;
  FormDefinition? _published;

  @override
  Future<FormDefinition?> loadDraft() async => _draft ?? _published;

  @override
  Future<void> publish(FormDefinition definition) async {
    _published = definition;
  }

  @override
  Future<void> saveDraft(FormDefinition definition) async {
    _draft = definition;
  }
}
