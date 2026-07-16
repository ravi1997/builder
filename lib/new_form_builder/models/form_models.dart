import 'dart:convert';

enum FormFieldType { text, number, date, dropdown, radio, checkbox, multiline, fileUpload, summary }

enum VerificationStatus { verified, pending, failed, expired, manualReview }

enum WorkflowStatus { draft, submitted, reviewed, approved, rejected, completed }

class ValidationRule {
  const ValidationRule({
    required this.type,
    this.value,
    this.message,
  });

  final String type;
  final Object? value;
  final String? message;

  Map<String, dynamic> toJson() => {'type': type, 'value': value, 'message': message};

  factory ValidationRule.fromJson(Map<String, dynamic> json) => ValidationRule(
        type: json['type'] as String,
        value: json['value'],
        message: json['message'] as String?,
      );
}

class ConditionalRule {
  const ConditionalRule({
    required this.fieldId,
    required this.operator,
    required this.value,
    this.action = 'show',
  });

  final String fieldId;
  final String operator;
  final Object? value;
  final String action;

  Map<String, dynamic> toJson() => {
        'fieldId': fieldId,
        'operator': operator,
        'value': value,
        'action': action,
      };

  factory ConditionalRule.fromJson(Map<String, dynamic> json) => ConditionalRule(
        fieldId: json['fieldId'] as String,
        operator: json['operator'] as String,
        value: json['value'],
        action: json['action'] as String? ?? 'show',
      );
}

class FormFieldModel {
  const FormFieldModel({
    required this.id,
    required this.type,
    required this.label,
    this.description,
    this.placeholder,
    this.defaultValue,
    this.required = false,
    this.validationRules = const <ValidationRule>[],
    this.conditionalRules = const <ConditionalRule>[],
    this.permissions = const <String>[],
    this.metadata = const <String, dynamic>{},
    this.layout = const <String, dynamic>{},
  });

  final String id;
  final FormFieldType type;
  final String label;
  final String? description;
  final String? placeholder;
  final Object? defaultValue;
  final bool required;
  final List<ValidationRule> validationRules;
  final List<ConditionalRule> conditionalRules;
  final List<String> permissions;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> layout;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
        'description': description,
        'placeholder': placeholder,
        'defaultValue': defaultValue,
        'required': required,
        'validationRules': validationRules.map((e) => e.toJson()).toList(),
        'conditionalRules': conditionalRules.map((e) => e.toJson()).toList(),
        'permissions': permissions,
        'metadata': metadata,
        'layout': layout,
      };

  factory FormFieldModel.fromJson(Map<String, dynamic> json) => FormFieldModel(
        id: json['id'] as String,
        type: FormFieldType.values.byName(json['type'] as String),
        label: json['label'] as String,
        description: json['description'] as String?,
        placeholder: json['placeholder'] as String?,
        defaultValue: json['defaultValue'],
        required: json['required'] as bool? ?? false,
        validationRules: (json['validationRules'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ValidationRule.fromJson)
            .toList(),
        conditionalRules: (json['conditionalRules'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ConditionalRule.fromJson)
            .toList(),
        permissions: (json['permissions'] as List<dynamic>? ?? const []).cast<String>(),
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
        layout: (json['layout'] as Map<String, dynamic>?) ?? const {},
      );
}

class FormSectionModel {
  const FormSectionModel({
    required this.id,
    required this.title,
    this.description,
    this.order = 0,
    this.visibilityRules = const <ConditionalRule>[],
    this.fields = const <FormFieldModel>[],
  });

  final String id;
  final String title;
  final String? description;
  final int order;
  final List<ConditionalRule> visibilityRules;
  final List<FormFieldModel> fields;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'order': order,
        'visibilityRules': visibilityRules.map((e) => e.toJson()).toList(),
        'fields': fields.map((e) => e.toJson()).toList(),
      };

  factory FormSectionModel.fromJson(Map<String, dynamic> json) => FormSectionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        order: json['order'] as int? ?? 0,
        visibilityRules: (json['visibilityRules'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ConditionalRule.fromJson)
            .toList(),
        fields: (json['fields'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(FormFieldModel.fromJson)
            .toList(),
      );
}

class WorkflowStep {
  const WorkflowStep({
    required this.id,
    required this.label,
    required this.status,
    this.assignee,
    this.dueDate,
  });

  final String id;
  final String label;
  final WorkflowStatus status;
  final String? assignee;
  final DateTime? dueDate;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'status': status.name,
        'assignee': assignee,
        'dueDate': dueDate?.toIso8601String(),
      };

  factory WorkflowStep.fromJson(Map<String, dynamic> json) => WorkflowStep(
        id: json['id'] as String,
        label: json['label'] as String,
        status: WorkflowStatus.values.byName(json['status'] as String),
        assignee: json['assignee'] as String?,
        dueDate: json['dueDate'] == null ? null : DateTime.parse(json['dueDate'] as String),
      );
}

class WorkflowDefinition {
  const WorkflowDefinition({
    required this.status,
    this.steps = const <WorkflowStep>[],
  });

  final WorkflowStatus status;
  final List<WorkflowStep> steps;

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'steps': steps.map((e) => e.toJson()).toList(),
      };

  factory WorkflowDefinition.fromJson(Map<String, dynamic> json) => WorkflowDefinition(
        status: WorkflowStatus.values.byName(json['status'] as String),
        steps: (json['steps'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(WorkflowStep.fromJson)
            .toList(),
      );
}

class AuditEntry {
  const AuditEntry({
    required this.actor,
    required this.action,
    required this.timestamp,
    this.reason,
    this.oldValue,
    this.newValue,
  });

  final String actor;
  final String action;
  final DateTime timestamp;
  final String? reason;
  final Object? oldValue;
  final Object? newValue;

  Map<String, dynamic> toJson() => {
        'actor': actor,
        'action': action,
        'timestamp': timestamp.toIso8601String(),
        'reason': reason,
        'oldValue': oldValue,
        'newValue': newValue,
      };
}

class FieldHistoryEntry {
  const FieldHistoryEntry({
    required this.fieldId,
    required this.actor,
    required this.changedAt,
    this.previousValue,
    this.currentValue,
  });

  final String fieldId;
  final String actor;
  final DateTime changedAt;
  final Object? previousValue;
  final Object? currentValue;

  Map<String, dynamic> toJson() => {
        'fieldId': fieldId,
        'actor': actor,
        'changedAt': changedAt.toIso8601String(),
        'previousValue': previousValue,
        'currentValue': currentValue,
      };
}

class DocumentAttachment {
  const DocumentAttachment({
    required this.id,
    required this.name,
    this.expiresAt,
  });

  final String id;
  final String name;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'expiresAt': expiresAt?.toIso8601String(),
      };
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.name,
    required this.timestamp,
    this.payload = const <String, dynamic>{},
  });

  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'payload': payload,
      };
}

class AccessPolicy {
  const AccessPolicy({
    this.roles = const <String>[],
    this.maskSensitiveFields = false,
  });

  final List<String> roles;
  final bool maskSensitiveFields;

  Map<String, dynamic> toJson() => {'roles': roles, 'maskSensitiveFields': maskSensitiveFields};
}

class FormDefinition {
  const FormDefinition({
    required this.id,
    required this.title,
    this.description,
    this.instructions,
    this.sections = const <FormSectionModel>[],
    this.workflow = const WorkflowDefinition(status: WorkflowStatus.draft),
    this.accessPolicy = const AccessPolicy(),
    this.version = 1,
    this.theme = const <String, dynamic>{},
    this.layout = const <String, dynamic>{},
    this.analytics = const <String, dynamic>{},
  });

  final String id;
  final String title;
  final String? description;
  final String? instructions;
  final List<FormSectionModel> sections;
  final WorkflowDefinition workflow;
  final AccessPolicy accessPolicy;
  final int version;
  final Map<String, dynamic> theme;
  final Map<String, dynamic> layout;
  final Map<String, dynamic> analytics;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'instructions': instructions,
        'sections': sections.map((e) => e.toJson()).toList(),
        'workflow': workflow.toJson(),
        'accessPolicy': accessPolicy.toJson(),
        'version': version,
        'theme': theme,
        'layout': layout,
        'analytics': analytics,
      };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());

  factory FormDefinition.fromJson(Map<String, dynamic> json) => FormDefinition(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        instructions: json['instructions'] as String?,
        sections: (json['sections'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(FormSectionModel.fromJson)
            .toList(),
        workflow: json['workflow'] == null
            ? const WorkflowDefinition(status: WorkflowStatus.draft)
            : WorkflowDefinition.fromJson(json['workflow'] as Map<String, dynamic>),
        accessPolicy: json['accessPolicy'] == null
            ? const AccessPolicy()
            : AccessPolicy(
                roles: (json['accessPolicy']['roles'] as List<dynamic>? ?? const []).cast<String>(),
                maskSensitiveFields: json['accessPolicy']['maskSensitiveFields'] as bool? ?? false,
              ),
        version: json['version'] as int? ?? 1,
        theme: (json['theme'] as Map<String, dynamic>?) ?? const {},
        layout: (json['layout'] as Map<String, dynamic>?) ?? const {},
        analytics: (json['analytics'] as Map<String, dynamic>?) ?? const {},
      );
}
