import '../models/form_models.dart';

class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
}

class FormValidator {
  const FormValidator();

  ValidationResult validateDefinition(FormDefinition definition) {
    final errors = <String, String>{};
    final seenIds = <String>{};

    for (final section in definition.sections) {
      for (final field in section.fields) {
        if (seenIds.contains(field.id)) {
          errors['field:${field.id}:duplicate'] = 'Duplicate field ID ${field.id}';
        } else {
          seenIds.add(field.id);
        }

        if (field.required && field.label.isEmpty) {
          errors['field:${field.id}:label'] = 'Required fields need a label';
        }
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
