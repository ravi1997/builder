import 'package:flutter/material.dart';

import '../models/form_element.dart';

class FormElementWidget extends StatelessWidget {
  const FormElementWidget({
    super.key,
    required this.element,
    required this.selected,
    required this.onTap,
    this.onCheckboxChanged,
    this.onDelete,
    this.dragHandle,
  });

  final FormElement element;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<bool>? onCheckboxChanged;
  final VoidCallback? onDelete;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300;
    return _buildCard(context, borderColor);
  }

  Widget _buildCard(BuildContext context, Color borderColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: selected ? 2 : 1),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onCheckboxChanged != null)
                    Checkbox(
                      value: selected,
                      onChanged: (value) => onCheckboxChanged!(value ?? false),
                    ),
                  if (dragHandle != null) ...[
                    dragHandle!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    element.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  if (element.required)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(999)),
                      child: const Text('Required', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  const Spacer(),
                  if (onDelete != null) ...[
                    IconButton(
                      tooltip: 'Delete question',
                      visualDensity: VisualDensity.compact,
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 18),
                    ),
                  ],
                  Text(element.type, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 12),
              _buildFieldPreview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldPreview(BuildContext context) {
    switch (element.type) {
      case 'textarea':
      case 'rich_text':
      case 'markdown':
      case 'code_block':
      case 'table':
      case 'list':
        return const _TextPreview(multiline: true);
      case 'checkbox':
      case 'boolean':
      case 'toggle':
      case 'yes_no':
        return Row(children: [Checkbox(value: false, onChanged: (_) {}), const Text('Option')]);
      case 'radio':
      case 'multi_radio':
      case 'single_choice':
        return Column(
          children: List.generate(3, (index) => ListTile(leading: const Icon(Icons.radio_button_checked), title: Text('Choice ${index + 1}'))),
        );
      case 'dropdown':
        return const _DropdownPreview();
      case 'slider':
        return Slider(value: 25, onChanged: (_) {});
      default:
        return TextField(
          decoration: InputDecoration(
            hintText: element.properties['placeholder'] as String? ?? 'Enter ${element.label.toLowerCase()}',
            border: const OutlineInputBorder(),
          ),
          maxLines: element.type == 'textarea' ? 4 : 1,
        );
    }
  }
}

class _TextPreview extends StatelessWidget {
  const _TextPreview({required this.multiline});

  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Placeholder'),
      minLines: multiline ? 4 : 1,
      maxLines: multiline ? 4 : 1,
    );
  }
}

class _DropdownPreview extends StatelessWidget {
  const _DropdownPreview();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: 'Option 1',
      items: const [
        DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
        DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
      ],
      onChanged: (_) {},
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
