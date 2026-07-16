import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/form_element.dart';

class SelectionSectionSummary {
  const SelectionSectionSummary({
    required this.sectionIndex,
    required this.title,
    required this.count,
    required this.totalCount,
    required this.isCurrent,
  });

  final int sectionIndex;
  final String title;
  final int count;
  final int totalCount;
  final bool isCurrent;
}

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({
    super.key,
    required this.element,
    required this.selectedCount,
    required this.sectionSummaries,
    required this.canMoveSelectedToSection,
    required this.onClearSelection,
    required this.onSelectAll,
    required this.onInvertSelection,
    required this.onDeleteSelected,
    required this.onDuplicateSelected,
    required this.onMoveSelectedToSection,
    required this.onSelectSection,
    required this.onMoveFromSection,
    required this.onSelectSectionAndMove,
    required this.onReorderSection,
    required this.onChanged,
  });

  final FormElement? element;
  final int selectedCount;
  final List<SelectionSectionSummary> sectionSummaries;
  final bool canMoveSelectedToSection;
  final VoidCallback onClearSelection;
  final VoidCallback onSelectAll;
  final VoidCallback onInvertSelection;
  final VoidCallback onDeleteSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onMoveSelectedToSection;
  final ValueChanged<int> onSelectSection;
  final ValueChanged<int> onMoveFromSection;
  final ValueChanged<int> onSelectSectionAndMove;
  final void Function(int oldIndex, int newIndex) onReorderSection;
  final ValueChanged<FormElement> onChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedCount > 1) {
      final theme = Theme.of(context);
      return Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          const SingleActivator(LogicalKeyboardKey.escape): const _ClearSelectionIntent(),
          const SingleActivator(LogicalKeyboardKey.delete): const _DeleteSelectedIntent(),
          const SingleActivator(LogicalKeyboardKey.backspace): const _DeleteSelectedIntent(),
          const SingleActivator(LogicalKeyboardKey.keyA, control: true): const _SelectAllIntent(),
          const SingleActivator(LogicalKeyboardKey.keyD, control: true): const _DuplicateSelectedIntent(),
          const SingleActivator(LogicalKeyboardKey.keyM, control: true): const _MoveSelectedIntent(),
          const SingleActivator(LogicalKeyboardKey.keyM, meta: true): const _MoveSelectedIntent(),
          const SingleActivator(LogicalKeyboardKey.keyS, alt: true): const _SelectSectionIntent(),
          const SingleActivator(LogicalKeyboardKey.keyM, alt: true): const _MoveSectionIntent(),
          const SingleActivator(LogicalKeyboardKey.keyJ, alt: true): const _SelectAndMoveSectionIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _ClearSelectionIntent: CallbackAction<_ClearSelectionIntent>(onInvoke: (_) {
              onClearSelection();
              return null;
            }),
            _DeleteSelectedIntent: CallbackAction<_DeleteSelectedIntent>(onInvoke: (_) {
              onDeleteSelected();
              return null;
            }),
            _SelectAllIntent: CallbackAction<_SelectAllIntent>(onInvoke: (_) {
              onSelectAll();
              return null;
            }),
            _DuplicateSelectedIntent: CallbackAction<_DuplicateSelectedIntent>(onInvoke: (_) {
              onDuplicateSelected();
              return null;
            }),
            _MoveSelectedIntent: CallbackAction<_MoveSelectedIntent>(onInvoke: (_) {
              if (canMoveSelectedToSection) onMoveSelectedToSection();
              return null;
            }),
            _SelectSectionIntent: CallbackAction<_SelectSectionIntent>(onInvoke: (_) {
              final summary = _currentSummary(sectionSummaries);
              if (summary != null) onSelectSection(summary.sectionIndex);
              return null;
            }),
            _MoveSectionIntent: CallbackAction<_MoveSectionIntent>(onInvoke: (_) {
              final summary = _currentSummary(sectionSummaries);
              if (summary != null) onMoveFromSection(summary.sectionIndex);
              return null;
            }),
            _SelectAndMoveSectionIntent: CallbackAction<_SelectAndMoveSectionIntent>(onInvoke: (_) {
              final summary = _currentSummary(sectionSummaries);
              if (summary != null) onSelectSectionAndMove(summary.sectionIndex);
              return null;
            }),
          },
          child: Focus(
            autofocus: true,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
            Text(
              '$selectedCount selected',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Bulk edit mode',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Quick bulk actions',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _IconBulkButton(
                          tooltip: 'Select All (Ctrl+A)',
                          icon: Icons.select_all,
                          onPressed: onSelectAll,
                        ),
                        _IconBulkButton(
                          tooltip: 'Unselect All (Esc)',
                          icon: Icons.horizontal_rule,
                          onPressed: onClearSelection,
                        ),
                        _IconBulkButton(
                          tooltip: 'Invert Selection',
                          icon: Icons.swap_horiz,
                          onPressed: onInvertSelection,
                        ),
                        _IconBulkButton(
                          tooltip: 'Delete Selected (Del)',
                          icon: Icons.delete_outline,
                          onPressed: onDeleteSelected,
                        ),
                        _IconBulkButton(
                          tooltip: 'Duplicate Selected (Ctrl+D)',
                          icon: Icons.copy,
                          onPressed: onDuplicateSelected,
                        ),
                        _IconBulkButton(
                          tooltip: 'Move Selected to Section (Ctrl+M)',
                          icon: Icons.drive_file_move,
                          onPressed: canMoveSelectedToSection ? onMoveSelectedToSection : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Keyboard: Esc clears, Del deletes, Ctrl+D duplicates, Ctrl+M moves.',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selection summary',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$selectedCount total selected',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    if (sectionSummaries.isNotEmpty) ...[
                      Text(
                        'Section breakdown',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 320;
                          return Column(
                            children: [
                              for (final summary in sectionSummaries)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _SectionActionChip(
                                    summary: summary,
                                    compact: compact,
                                    onSelectSection: () => onSelectSection(summary.sectionIndex),
                                    onMoveSelectedFromSection: () => onMoveFromSection(summary.sectionIndex),
                                    onSelectSectionAndMove: () => onSelectSectionAndMove(summary.sectionIndex),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _SelectionMatrix(
                        sectionSummaries: sectionSummaries,
                        onSelectSection: onSelectSection,
                        onMoveFromSection: onMoveFromSection,
                        onSelectSectionAndMove: onSelectSectionAndMove,
                        onReorderSection: onReorderSection,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      'Bulk properties are disabled while multiple items are selected. Use the actions above to adjust the selection or act on a specific section.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
            ),
          ),
        ),
      );
    }
    final current = element;
    if (current == null) {
      return const Center(child: Text('Select a field to edit its properties.'));
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text('Properties', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _Section(
          title: 'Common Properties',
          children: [
            TextFormField(
              initialValue: current.label,
              decoration: const InputDecoration(labelText: 'Label'),
              onChanged: (value) => onChanged(current.copyWith(label: value)),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: current.properties['description'] as String? ?? '',
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => onChanged(current.copyWith(properties: {...current.properties, 'description': value})),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: current.properties['placeholder'] as String? ?? '',
              decoration: const InputDecoration(labelText: 'Placeholder'),
              onChanged: (value) => onChanged(current.copyWith(properties: {...current.properties, 'placeholder': value})),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: current.required,
              title: const Text('Required'),
              onChanged: (value) => onChanged(current.copyWith(required: value)),
            ),
            TextFormField(
              initialValue: current.properties['defaultValue']?.toString() ?? '',
              decoration: const InputDecoration(labelText: 'Default Value'),
              onChanged: (value) => onChanged(current.copyWith(properties: {...current.properties, 'defaultValue': value})),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: (current.properties['validationRules'] as List?)?.join(', ') ?? '',
              decoration: const InputDecoration(labelText: 'Validation Rules'),
              onChanged: (value) => onChanged(current.copyWith(properties: {...current.properties, 'validationRules': value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()})),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Section(
          title: 'Type Specific Properties',
          children: _buildTypeSpecificFields(context, current),
        ),
      ],
    );
  }

  List<Widget> _buildTypeSpecificFields(BuildContext context, FormElement current) {
    final props = current.properties;
    if (current.type == 'text' || current.type == 'textarea' || current.type == 'email' || current.type == 'phone' || current.type == 'url') {
      return [
        TextFormField(initialValue: '${props['minLength'] ?? 0}', decoration: const InputDecoration(labelText: 'Min Length'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'minLength': int.tryParse(value) ?? 0}))),
        const SizedBox(height: 12),
        TextFormField(initialValue: '${props['maxLength'] ?? 255}', decoration: const InputDecoration(labelText: 'Max Length'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'maxLength': int.tryParse(value) ?? 255}))),
      ];
    }
    if (current.type == 'integer' || current.type == 'decimal' || current.type.contains('number') || current.type == 'currency' || current.type == 'percentage' || current.type == 'score') {
      return [
        TextFormField(initialValue: '${props['minimum'] ?? 0}', decoration: const InputDecoration(labelText: 'Minimum'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'minimum': num.tryParse(value) ?? 0}))),
        const SizedBox(height: 12),
        TextFormField(initialValue: '${props['maximum'] ?? 100}', decoration: const InputDecoration(labelText: 'Maximum'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'maximum': num.tryParse(value) ?? 100}))),
      ];
    }
    if (current.type == 'dropdown' || current.type == 'radio' || current.type == 'checkbox' || current.type == 'checkbox_group' || current.type == 'multi_radio' || current.type == 'multi_choice' || current.type == 'single_choice') {
      return [
        TextFormField(
          initialValue: ((props['options'] as List?) ?? const ['Option 1', 'Option 2']).join(', '),
          decoration: const InputDecoration(labelText: 'Options list'),
          onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'options': value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()})),
        ),
      ];
    }
    if (current.type == 'slider') {
      return [
        TextFormField(initialValue: '${props['min'] ?? 0}', decoration: const InputDecoration(labelText: 'Min Value'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'min': double.tryParse(value) ?? 0}))),
        const SizedBox(height: 12),
        TextFormField(initialValue: '${props['max'] ?? 100}', decoration: const InputDecoration(labelText: 'Max Value'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'max': double.tryParse(value) ?? 100}))),
        const SizedBox(height: 12),
        TextFormField(initialValue: '${props['step'] ?? 1}', decoration: const InputDecoration(labelText: 'Step'), keyboardType: TextInputType.number, onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'step': double.tryParse(value) ?? 1}))),
      ];
    }
    if (current.type == 'date') {
      return [
        TextFormField(initialValue: '${props['range'] ?? 'Any date'}', decoration: const InputDecoration(labelText: 'Allowed range'), onChanged: (value) => onChanged(current.copyWith(properties: {...props, 'range': value}))),
      ];
    }
    return [
      Text('No type-specific options are required for ${current.type}.', style: Theme.of(context).textTheme.bodyMedium),
    ];
  }
}

class _IconBulkButton extends StatelessWidget {
  const _IconBulkButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _SectionActionChip extends StatelessWidget {
  const _SectionActionChip({
    required this.summary,
    required this.compact,
    required this.onSelectSection,
    required this.onMoveSelectedFromSection,
    required this.onSelectSectionAndMove,
  });

  final SelectionSectionSummary summary;
  final bool compact;
  final VoidCallback onSelectSection;
  final VoidCallback onMoveSelectedFromSection;
  final VoidCallback onSelectSectionAndMove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: summary.isCurrent ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onSelectSection,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                summary.isCurrent ? Icons.radio_button_checked : Icons.view_agenda_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                compact ? summary.title : '${summary.title} (${summary.count}/${summary.totalCount})',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Select all in this section',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                onPressed: onSelectSection,
                icon: const Icon(Icons.select_all, size: 16),
              ),
              IconButton(
                tooltip: 'Move selected items from this section only',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                onPressed: onMoveSelectedFromSection,
                icon: const Icon(Icons.drive_file_move, size: 16),
              ),
              IconButton(
                tooltip: 'Select and move',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                onPressed: onSelectSectionAndMove,
                icon: const Icon(Icons.alt_route, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionMatrix extends StatelessWidget {
  const _SelectionMatrix({
    required this.sectionSummaries,
    required this.onSelectSection,
    required this.onMoveFromSection,
    required this.onSelectSectionAndMove,
    required this.onReorderSection,
  });

  final List<SelectionSectionSummary> sectionSummaries;
  final ValueChanged<int> onSelectSection;
  final ValueChanged<int> onMoveFromSection;
  final ValueChanged<int> onSelectSectionAndMove;
  final void Function(int oldIndex, int newIndex) onReorderSection;

  @override
  Widget build(BuildContext context) {
    if (sectionSummaries.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selection matrix',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: sectionSummaries.length,
              onReorderItem: (oldIndex, newIndex) {
                if (oldIndex < newIndex) newIndex -= 1;
                onReorderSection(
                  sectionSummaries[oldIndex].sectionIndex,
                  sectionSummaries[newIndex.clamp(0, sectionSummaries.length - 1)].sectionIndex,
                );
              },
              itemBuilder: (context, index) {
                final summary = sectionSummaries[index];
                final score = summary.totalCount == 0 ? 0.0 : summary.count / summary.totalCount;
                return Padding(
                  key: ValueKey(summary.sectionIndex),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) => details.data != summary.sectionIndex,
                    onAcceptWithDetails: (details) {
                      onSelectSectionAndMove(details.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      final isActiveDrop = candidateData.isNotEmpty;
                      final row = _SectionRowCard(
                        summary: summary,
                        score: score,
                        isDragging: false,
                        isDropTarget: isActiveDrop,
                        onTap: () => onSelectSection(summary.sectionIndex),
                        onSelectSection: () => onSelectSection(summary.sectionIndex),
                        onMoveFromSection: () => onMoveFromSection(summary.sectionIndex),
                        onSelectSectionAndMove: () => onSelectSectionAndMove(summary.sectionIndex),
                      );
                      if (summary.count <= 0) {
                        return row;
                      }
                      return Draggable<int>(
                        data: summary.sectionIndex,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _SectionRowCard(
                            summary: summary,
                            score: score,
                            isDragging: true,
                            isDropTarget: false,
                            onTap: () => onSelectSection(summary.sectionIndex),
                            onSelectSection: () => onSelectSection(summary.sectionIndex),
                            onMoveFromSection: () => onMoveFromSection(summary.sectionIndex),
                            onSelectSectionAndMove: () => onSelectSectionAndMove(summary.sectionIndex),
                          ),
                        ),
                        childWhenDragging: Opacity(opacity: 0.45, child: row),
                        child: row,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionRowCard extends StatelessWidget {
  const _SectionRowCard({
    required this.summary,
    required this.score,
    required this.isDragging,
    required this.isDropTarget,
    required this.onTap,
    required this.onSelectSection,
    required this.onMoveFromSection,
    required this.onSelectSectionAndMove,
  });

  final SelectionSectionSummary summary;
  final double score;
  final bool isDragging;
  final bool isDropTarget;
  final VoidCallback onTap;
  final VoidCallback onSelectSection;
  final VoidCallback onMoveFromSection;
  final VoidCallback onSelectSectionAndMove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isDropTarget ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35) : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: summary.isCurrent ? theme.colorScheme.primary : (isDropTarget ? theme.colorScheme.primary : theme.colorScheme.outlineVariant),
          width: summary.isCurrent || isDropTarget ? 1.4 : 1,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ReorderableDelayedDragStartListener(
                    index: summary.sectionIndex,
                    child: Icon(Icons.drag_indicator, color: theme.colorScheme.outline),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary.title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  _SectionMiniMenu(
                    summary: summary,
                    onSelectSection: onSelectSection,
                    onMoveFromSection: onMoveFromSection,
                    onSelectSectionAndMove: onSelectSectionAndMove,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: score.clamp(0.0, 1.0)),
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _HeatBadge(
                    title: '${summary.count} selected',
                    count: summary.count,
                    totalCount: summary.totalCount == 0 ? 1 : summary.totalCount,
                    isCurrent: summary.count > 0,
                  ),
                  const SizedBox(width: 8),
                  _HeatBadge(
                    title: '${summary.totalCount} total',
                    count: summary.totalCount,
                    totalCount: summary.totalCount == 0 ? 1 : summary.totalCount,
                    isCurrent: summary.isCurrent,
                    neutral: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Drop selected items here',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDropTarget ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SelectionSectionSummary? _currentSummary(List<SelectionSectionSummary> summaries) {
  for (final summary in summaries) {
    if (summary.isCurrent && summary.count > 0) return summary;
  }
  for (final summary in summaries) {
    if (summary.count > 0) return summary;
  }
  return summaries.isEmpty ? null : summaries.first;
}

class _ClearSelectionIntent extends Intent {
  const _ClearSelectionIntent();
}

class _DeleteSelectedIntent extends Intent {
  const _DeleteSelectedIntent();
}

class _SelectAllIntent extends Intent {
  const _SelectAllIntent();
}

class _DuplicateSelectedIntent extends Intent {
  const _DuplicateSelectedIntent();
}

class _MoveSelectedIntent extends Intent {
  const _MoveSelectedIntent();
}

class _SelectSectionIntent extends Intent {
  const _SelectSectionIntent();
}

class _MoveSectionIntent extends Intent {
  const _MoveSectionIntent();
}

class _SelectAndMoveSectionIntent extends Intent {
  const _SelectAndMoveSectionIntent();
}

class _HeatBadge extends StatelessWidget {
  const _HeatBadge({
    required this.title,
    required this.count,
    required this.totalCount,
    required this.isCurrent,
    this.neutral = false,
  });

  final String title;
  final int count;
  final int totalCount;
  final bool isCurrent;
  final bool neutral;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intensity = totalCount == 0 ? 0.0 : (count / totalCount).clamp(0.0, 1.0);
    final background = neutral
        ? theme.colorScheme.surfaceContainerHighest
        : Color.lerp(
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.primaryContainer,
            intensity,
          )!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isCurrent ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isCurrent ? theme.colorScheme.primary : null,
          ),
        ),
      ),
    );
  }
}

class _SectionMiniMenu extends StatelessWidget {
  const _SectionMiniMenu({
    required this.summary,
    required this.onSelectSection,
    required this.onMoveFromSection,
    required this.onSelectSectionAndMove,
  });

  final SelectionSectionSummary summary;
  final VoidCallback onSelectSection;
  final VoidCallback onMoveFromSection;
  final VoidCallback onSelectSectionAndMove;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Section actions',
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'select':
            onSelectSection();
            break;
          case 'move':
            onMoveFromSection();
            break;
          case 'combo':
            onSelectSectionAndMove();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'select',
          child: Text('Select ${summary.title}'),
        ),
        PopupMenuItem<String>(
          value: 'move',
          child: Text('Move from ${summary.title}'),
        ),
        PopupMenuItem<String>(
          value: 'combo',
          child: Text('Select and move ${summary.title}'),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...children,
        ]),
      ),
    );
  }
}
