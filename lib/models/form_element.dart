class FormElement {
  FormElement({
    required this.id,
    required this.type,
    required this.label,
    required this.required,
    Map<String, dynamic>? properties,
  }) : properties = properties ?? <String, dynamic>{};

  final String id;
  final String type;
  final String label;
  final bool required;
  final Map<String, dynamic> properties;

  FormElement copyWith({
    String? id,
    String? type,
    String? label,
    bool? required,
    Map<String, dynamic>? properties,
  }) {
    return FormElement(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      required: required ?? this.required,
      properties: properties ?? Map<String, dynamic>.from(this.properties),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'label': label,
        'required': required,
        'properties': properties,
      };
}
