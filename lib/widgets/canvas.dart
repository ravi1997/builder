import 'package:flutter/material.dart';

import '../models/form_element.dart';
import '../models/form_section.dart';
import '../utils/field_registry.dart';
import 'form_element_widget.dart';

class BuilderCanvas extends StatelessWidget {
  const BuilderCanvas({
    super.key,
    required this.sections,
    required this.selectedId,
    required this.selectedIds,
    required this.previewMode,
    required this.onSelect,
    required this.onToggleSelect,
    required this.onDrop,
    required this.onReorderInSection,
    required this.onMoveElementsToSection,
    required this.onMoveElementToSection,
    required this.onDeleteSection,
    required this.onDeleteElement,
    required this.onAddSection,
  });

  final List<FormSection> sections;
  final String? selectedId;
  final Set<String> selectedIds;
  final bool previewMode;
  final ValueChanged<String> onSelect;
  final void Function(String id) onToggleSelect;
  final void Function(FieldItem item, int sectionIndex, int? index) onDrop;
  final void Function(int sectionIndex, int oldIndex, int newIndex) onReorderInSection;
  final void Function(List<String> ids, int targetSectionIndex, int? targetIndex) onMoveElementsToSection;
  final void Function(String elementId, int targetSectionIndex, int? targetIndex) onMoveElementToSection;
  final ValueChanged<int> onDeleteSection;
  final ValueChanged<String> onDeleteElement;
  final VoidCallback onAddSection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: onAddSection,
              icon: const Icon(Icons.add),
              label: const Text('Add Section'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: sections.isEmpty
              ? _EmptyCanvas(onDrop: (item) => onDrop(item, 0, null))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: sections.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = sections[sectionIndex];
                    return _SectionCard(
                      section: section,
                      sectionIndex: sectionIndex,
                      selectedId: selectedId,
                      selectedIds: selectedIds,
                      onSelect: onSelect,
                      onToggleSelect: onToggleSelect,
                      onDrop: onDrop,
                      onReorderInSection: onReorderInSection,
                      onMoveElementsToSection: onMoveElementsToSection,
                      onMoveElementToSection: onMoveElementToSection,
                      onDeleteSection: onDeleteSection,
                      onDeleteElement: onDeleteElement,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyCanvas extends StatelessWidget {
  const _EmptyCanvas({required this.onDrop});

  final ValueChanged<FieldItem> onDrop;

  @override
  Widget build(BuildContext context) {
    return DragTarget<FieldItem>(
      key: const ValueKey('canvas-empty-target'),
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.04) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: const Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.playlist_add, size: 48),
                    SizedBox(height: 8),
                    Text('Drop a field here to begin the form canvas.'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.section,
    required this.sectionIndex,
    required this.selectedId,
    required this.selectedIds,
    required this.onSelect,
    required this.onToggleSelect,
    required this.onDrop,
    required this.onReorderInSection,
    required this.onMoveElementsToSection,
    required this.onMoveElementToSection,
    required this.onDeleteSection,
    required this.onDeleteElement,
  });

  final FormSection section;
  final int sectionIndex;
  final String? selectedId;
  final Set<String> selectedIds;
  final ValueChanged<String> onSelect;
  final void Function(String id) onToggleSelect;
  final void Function(FieldItem item, int sectionIndex, int? index) onDrop;
  final void Function(int sectionIndex, int oldIndex, int newIndex) onReorderInSection;
  final void Function(List<String> ids, int targetSectionIndex, int? targetIndex) onMoveElementsToSection;
  final void Function(String elementId, int targetSectionIndex, int? targetIndex) onMoveElementToSection;
  final ValueChanged<int> onDeleteSection;
  final ValueChanged<String> onDeleteElement;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      key: ValueKey('section-drop-$sectionIndex'),
      onAcceptWithDetails: (details) {
        final data = details.data;
        if (data is _SectionDragPayload) {
          onMoveElementsToSection(data.ids, sectionIndex, section.elements.length);
        } else if (data is FormElement) {
          onMoveElementToSection(data.id, sectionIndex, section.elements.length);
        } else if (data is FieldItem) {
          onDrop(data, sectionIndex, section.elements.length);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x0D000000), blurRadius: 18, offset: Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                      Text(
                        '${section.elements.length} questions',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Delete section',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => onDeleteSection(sectionIndex),
                        icon: const Icon(Icons.delete_outline, size: 18),
                      ),
                    ],
                  ),
                ),
                if (section.elements.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Drop questions into this section.'),
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: section.elements.length,
                    onReorderItem: (oldIndex, newIndex) => onReorderInSection(sectionIndex, oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final element = section.elements[index];
                      return KeyedSubtree(
                        key: ValueKey(element.id),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _InsertionSlot(
                              sectionIndex: sectionIndex,
                              targetIndex: index,
                              onMoveElementToSection: onMoveElementToSection,
                              onMoveElementsToSection: onMoveElementsToSection,
                              onInsertField: onDrop,
                            ),
                            FormElementWidget(
                              element: element,
                              selected: selectedIds.contains(element.id),
                              onTap: () => onSelect(element.id),
                              onCheckboxChanged: (_) => onToggleSelect(element.id),
                              onDelete: () => onDeleteElement(element.id),
                              dragHandle: _DraggableHandle(
                                element: element,
                                sourceSectionIndex: sectionIndex,
                                selectedIds: selectedIds,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                _InsertionSlot(
                  sectionIndex: sectionIndex,
                  targetIndex: section.elements.length,
                  onMoveElementToSection: onMoveElementToSection,
                  onMoveElementsToSection: onMoveElementsToSection,
                  onInsertField: onDrop,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InsertionSlot extends StatefulWidget {
  const _InsertionSlot({
    required this.sectionIndex,
    required this.targetIndex,
    required this.onMoveElementToSection,
    required this.onMoveElementsToSection,
    required this.onInsertField,
  });

  final int sectionIndex;
  final int targetIndex;
  final void Function(String elementId, int targetSectionIndex, int? targetIndex) onMoveElementToSection;
  final void Function(List<String> ids, int targetSectionIndex, int? targetIndex) onMoveElementsToSection;
  final void Function(FieldItem item, int sectionIndex, int? index) onInsertField;

  @override
  State<_InsertionSlot> createState() => _InsertionSlotState();
}

class _InsertionSlotState extends State<_InsertionSlot> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Object>(
      onWillAcceptWithDetails: (_) {
        if (!_hovering) {
          setState(() {
            _hovering = true;
          });
        }
        return true;
      },
      onLeave: (_) {
        if (_hovering) {
          setState(() {
            _hovering = false;
          });
        }
      },
      onAcceptWithDetails: (details) {
        if (_hovering) {
          setState(() {
            _hovering = false;
          });
        }
        final data = details.data;
        if (data is _SectionDragPayload) {
          widget.onMoveElementsToSection(data.ids, widget.sectionIndex, widget.targetIndex);
        } else if (data is FormElement) {
          widget.onMoveElementToSection(data.id, widget.sectionIndex, widget.targetIndex);
        } else if (data is FieldItem) {
          widget.onInsertField(data, widget.sectionIndex, widget.targetIndex);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final active = _hovering || candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          height: active ? 18 : 10,
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DraggableHandle extends StatelessWidget {
  const _DraggableHandle({
    required this.element,
    required this.sourceSectionIndex,
    required this.selectedIds,
  });

  final FormElement element;
  final int sourceSectionIndex;
  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    final payloadIds = selectedIds.contains(element.id) && selectedIds.length > 1
        ? selectedIds.toList(growable: false)
        : <String>[element.id];
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Tooltip(
        message: payloadIds.length > 1 ? 'Drag selected questions' : 'Drag question',
        child: Draggable<_SectionDragPayload>(
          data: _SectionDragPayload(
            sourceSectionIndex: sourceSectionIndex,
            ids: payloadIds,
          ),
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 360,
              height: 84,
              child: _DragPreview(
                title: payloadIds.length > 1 ? '${payloadIds.length} questions' : element.label,
                subtitle: element.type,
              ),
            ),
          ),
          childWhenDragging: const Icon(Icons.drag_indicator, size: 18),
          child: const Icon(Icons.drag_indicator, size: 18),
        ),
      ),
    );
  }
}

class _SectionDragPayload {
  const _SectionDragPayload({required this.sourceSectionIndex, required this.ids});

  final int sourceSectionIndex;
  final List<String> ids;
}

class _DragPreview extends StatelessWidget {
  const _DragPreview({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
