import 'form_element.dart';

class FormSection {
  FormSection({
    required this.id,
    required this.title,
    List<FormElement>? elements,
  }) : elements = elements ?? <FormElement>[];

  final String id;
  final String title;
  final List<FormElement> elements;

  FormSection copyWith({
    String? id,
    String? title,
    List<FormElement>? elements,
  }) {
    return FormSection(
      id: id ?? this.id,
      title: title ?? this.title,
      elements: elements ?? List<FormElement>.from(this.elements),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'elements': elements.map((element) => element.toJson()).toList(),
      };
}
