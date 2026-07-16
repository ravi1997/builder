import '../models/form_models.dart';

class FormValidationResult {
  const FormValidationResult({required this.errors});

  final Map<String, String> errors;

  bool get isValid => errors.isEmpty;
}

class FormValidator {
  const FormValidator();

  FormValidationResult validateDefinition(FormDefinition definition) {
    final errors = <String, String>{};
    final ids = <String>{};
    for (final section in definition.sections) {
      if (!ids.add(section.id)) {
        errors['section:${section.id}'] = 'Duplicate section id';
      }
      for (final field in section.fields) {
        if (!ids.add(field.id)) {
          errors['field:${field.id}'] = 'Duplicate field id';
        }
        if (field.required && field.label.trim().isEmpty) {
          errors['field:${field.id}:label'] = 'Required fields need a label';
        }
      }
    }
    return FormValidationResult(errors: errors);
  }

  FormValidationResult validateSubmission({
    required FormDefinition definition,
    required Map<String, Object?> values,
  }) {
    final errors = <String, String>{};
    for (final section in definition.sections) {
      for (final field in section.fields) {
        final value = values[field.id];
        if (field.required && (value == null || value.toString().trim().isEmpty)) {
          errors[field.id] = 'This field is required';
        }
        for (final rule in field.validationRules) {
          switch (rule.type) {
            case 'regex':
              final pattern = RegExp(rule.value as String);
              if (value is String && !pattern.hasMatch(value)) {
                errors[field.id] = rule.message ?? 'Invalid format';
              }
              break;
            case 'min':
              final min = rule.value as num;
              final numeric = num.tryParse('$value');
              if (numeric != null && numeric < min) {
                errors[field.id] = rule.message ?? 'Value too small';
              }
              break;
            case 'max':
              final max = rule.value as num;
              final numeric = num.tryParse('$value');
              if (numeric != null && numeric > max) {
                errors[field.id] = rule.message ?? 'Value too large';
              }
              break;
          }
        }
      }
    }
    return FormValidationResult(errors: errors);
  }
}
