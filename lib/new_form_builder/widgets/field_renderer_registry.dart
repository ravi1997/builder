import 'package:flutter/material.dart';

import '../models/form_models.dart';

typedef FieldRenderer = Widget Function(
  BuildContext context,
  FormFieldModel field,
  Object? value,
  ValueChanged<Object?> onChanged,
  bool hasError,
);

class FieldRendererRegistry {
  const FieldRendererRegistry._();

  static FieldRenderer resolve(FormFieldType type) {
    switch (type) {
      case FormFieldType.text:
        return _text;
      case FormFieldType.number:
        return _number;
      case FormFieldType.date:
        return _date;
      case FormFieldType.dropdown:
        return _dropdown;
      case FormFieldType.radio:
        return _radio;
      case FormFieldType.checkbox:
        return _checkbox;
      case FormFieldType.multiline:
        return _multiline;
      case FormFieldType.fileUpload:
        return _fileUpload;
      case FormFieldType.summary:
        return _summary;
    }
  }

  static Widget _text(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return TextFormField(
      initialValue: value?.toString(),
      decoration: InputDecoration(labelText: field.label, errorText: hasError ? 'Validation error' : null),
      onChanged: onChanged,
    );
  }

  static Widget _number(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return TextFormField(
      initialValue: value?.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: field.label, errorText: hasError ? 'Validation error' : null),
      onChanged: onChanged,
    );
  }

  static Widget _date(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return ListTile(
      title: Text(field.label),
      subtitle: Text(value?.toString() ?? field.placeholder ?? 'Pick a date'),
      trailing: const Icon(Icons.date_range_outlined),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => onChanged(DateTime.now().toIso8601String()),
    );
  }

  static Widget _dropdown(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return DropdownButtonFormField<String>(
      initialValue: value?.toString(),
      decoration: InputDecoration(labelText: field.label, errorText: hasError ? 'Validation error' : null),
      items: const [
        DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
        DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
      ],
      onChanged: onChanged,
    );
  }

  static Widget _radio(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label),
        RadioGroup<String>(
          groupValue: value?.toString(),
          onChanged: onChanged,
          child: Column(
            children: const [
              RadioListTile<String>(value: 'Option 1', title: Text('Option 1')),
              RadioListTile<String>(value: 'Option 2', title: Text('Option 2')),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _checkbox(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return CheckboxListTile(
      value: value == true,
      onChanged: onChanged,
      title: Text(field.label),
    );
  }

  static Widget _multiline(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return TextFormField(
      initialValue: value?.toString(),
      minLines: 3,
      maxLines: 5,
      decoration: InputDecoration(labelText: field.label, errorText: hasError ? 'Validation error' : null),
      onChanged: onChanged,
    );
  }

  static Widget _fileUpload(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return OutlinedButton.icon(
      onPressed: () => onChanged('document.pdf'),
      icon: const Icon(Icons.upload_file),
      label: Text(field.label),
    );
  }

  static Widget _summary(BuildContext context, FormFieldModel field, Object? value, ValueChanged<Object?> onChanged, bool hasError) {
    return Card(
      child: ListTile(
        title: Text(field.label),
        subtitle: Text(value?.toString() ?? 'Summary block'),
      ),
    );
  }
}
