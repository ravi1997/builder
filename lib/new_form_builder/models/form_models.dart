enum FormFieldType {
  text,
  number,
  date,
  checkbox,
}

class FormFieldModel {
  final String id;
  final FormFieldType type;
  final String label;
  final bool required;

  const FormFieldModel({
    required this.id,
    required this.type,
    required this.label,
    this.required = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
        'required': required,
      };

  factory FormFieldModel.fromJson(Map<String, dynamic> json) => FormFieldModel(
        id: json['id'] as String,
        type: FormFieldType.values.byName(json['type'] as String),
        label: json['label'] as String,
        required: json['required'] as bool? ?? false,
      );
}

class FormSectionModel {
  final String id;
  final String title;
  final List<FormFieldModel> fields;

  const FormSectionModel({
    required this.id,
    required this.title,
    required this.fields,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fields': fields.map((e) => e.toJson()).toList(),
      };

  factory FormSectionModel.fromJson(Map<String, dynamic> json) => FormSectionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        fields: (json['fields'] as List<dynamic>)
            .map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

enum WorkflowStatus {
  draft,
  published,
  archived,
}

class WorkflowDefinition {
  final WorkflowStatus status;

  const WorkflowDefinition({
    this.status = WorkflowStatus.draft,
  });

  Map<String, dynamic> toJson() => {
        'status': status.name,
      };

  factory WorkflowDefinition.fromJson(Map<String, dynamic> json) => WorkflowDefinition(
        status: WorkflowStatus.values.byName(json['status'] as String? ?? 'draft'),
      );
}

class AccessPolicy {
  final List<String> roles;
  final bool maskSensitiveFields;

  const AccessPolicy({
    this.roles = const [],
    this.maskSensitiveFields = false,
  });

  Map<String, dynamic> toJson() => {
        'roles': roles,
        'maskSensitiveFields': maskSensitiveFields,
      };

  factory AccessPolicy.fromJson(Map<String, dynamic> json) => AccessPolicy(
        roles: List<String>.from(json['roles'] as List<dynamic>? ?? []),
        maskSensitiveFields: json['maskSensitiveFields'] as bool? ?? false,
      );
}

class FormDefinition {
  final String id;
  final String title;
  final List<FormSectionModel> sections;
  final WorkflowDefinition workflow;
  final AccessPolicy accessPolicy;
  final int version;

  const FormDefinition({
    required this.id,
    required this.title,
    required this.sections,
    this.workflow = const WorkflowDefinition(),
    this.accessPolicy = const AccessPolicy(),
    this.version = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sections': sections.map((e) => e.toJson()).toList(),
        'workflow': workflow.toJson(),
        'accessPolicy': accessPolicy.toJson(),
        'version': version,
      };

  factory FormDefinition.fromJson(Map<String, dynamic> json) => FormDefinition(
        id: json['id'] as String,
        title: json['title'] as String,
        sections: (json['sections'] as List<dynamic>)
            .map((e) => FormSectionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        workflow: json['workflow'] != null
            ? WorkflowDefinition.fromJson(json['workflow'] as Map<String, dynamic>)
            : const WorkflowDefinition(),
        accessPolicy: json['accessPolicy'] != null
            ? AccessPolicy.fromJson(json['accessPolicy'] as Map<String, dynamic>)
            : const AccessPolicy(),
        version: json['version'] as int? ?? 1,
      );
}
