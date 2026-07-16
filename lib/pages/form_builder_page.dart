import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/form_builder_provider.dart';
import '../widgets/canvas.dart';
import '../widgets/component_library.dart';
import '../widgets/properties_panel.dart';
import '../widgets/toolbar.dart';

class FormBuilderPage extends ConsumerStatefulWidget {
  const FormBuilderPage({super.key});

  @override
  ConsumerState<FormBuilderPage> createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends ConsumerState<FormBuilderPage> {
  static const String _leftWidthKey = 'form_builder_left_width';
  static const String _rightWidthKey = 'form_builder_right_width';
  static const String _leftCollapsedKey = 'form_builder_left_collapsed';
  static const String _rightCollapsedKey = 'form_builder_right_collapsed';
  double _leftWidth = 320;
  double _rightWidth = 320;
  bool _leftCollapsed = false;
  bool _rightCollapsed = false;
  bool _hasLoadedWidths = false;

  static const double _minPanelWidth = 260;
  static const double _minCanvasWidth = 420;
  static const double _gutterWidth = 10;

  @override
  void initState() {
    super.initState();
    _loadWidths();
  }

  Future<void> _loadWidths() async {
    double? left;
    double? right;
    bool? leftCollapsed;
    bool? rightCollapsed;
    try {
      final prefs = await SharedPreferences.getInstance();
      left = prefs.getDouble(_leftWidthKey);
      right = prefs.getDouble(_rightWidthKey);
      leftCollapsed = prefs.getBool(_leftCollapsedKey);
      rightCollapsed = prefs.getBool(_rightCollapsedKey);
    } on MissingPluginException {
      // Ignore storage bootstrap failures on unsupported runtimes.
    }
    if (!mounted) return;
    setState(() {
      if (left != null) _leftWidth = left;
      if (right != null) _rightWidth = right;
      if (leftCollapsed != null) _leftCollapsed = leftCollapsed;
      if (rightCollapsed != null) _rightCollapsed = rightCollapsed;
      _hasLoadedWidths = true;
    });
  }

  Future<void> _saveWidths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_leftWidthKey, _leftWidth);
      await prefs.setDouble(_rightWidthKey, _rightWidth);
      await prefs.setBool(_leftCollapsedKey, _leftCollapsed);
      await prefs.setBool(_rightCollapsedKey, _rightCollapsed);
    } on MissingPluginException {
      // Ignore storage write failures on unsupported runtimes.
    }
  }

  Future<int?> _pickTargetSectionDialog(
    BuildContext context,
    String title,
    List<String> sectionTitles,
  ) async {
    if (sectionTitles.isEmpty) return null;
    var targetIndex = 0;
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: DropdownButtonFormField<int>(
                initialValue: targetIndex,
                decoration: const InputDecoration(labelText: 'Target section'),
                items: [
                  for (var i = 0; i < sectionTitles.length; i++)
                    DropdownMenuItem<int>(
                      value: i,
                      child: Text(sectionTitles[i]),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setDialogState(() => targetIndex = value);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(targetIndex),
                  child: const Text('Choose'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formBuilderProvider);
    final notifier = ref.read(formBuilderProvider.notifier);
    final selected = notifier.selectedElement;
    final propertiesTitle = state.selectedElementIds.length > 1
        ? '${state.selectedElementIds.length} selected'
        : 'Properties Inspector';
    final currentSelectedId = state.selectedElementId;
    final selectedSectionIndex = currentSelectedId == null
        ? null
        : state.sections.indexWhere((section) => section.elements.any((element) => element.id == currentSelectedId));
    final sectionSummaries = [
      for (var i = 0; i < state.sections.length; i++)
        SelectionSectionSummary(
          sectionIndex: i,
          title: state.sections[i].title,
          count: state.sections[i].elements.where((element) => state.selectedElementIds.contains(element.id)).length,
          totalCount: state.sections[i].elements.length,
          isCurrent: selectedSectionIndex == i,
        ),
    ].toList(growable: false);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final available = screenWidth - 32 - (_gutterWidth * 2);
    final maxSideWidth = ((available - _minCanvasWidth) / 2).clamp(_minPanelWidth, 520.0);
    final leftWidth = _leftCollapsed ? 48.0 : _leftWidth.clamp(_minPanelWidth, maxSideWidth).toDouble();
    final rightWidth = _rightCollapsed ? 48.0 : _rightWidth.clamp(_minPanelWidth, maxSideWidth).toDouble();
    final canvasWidth = (available - leftWidth - rightWidth).clamp(_minCanvasWidth, double.infinity).toDouble();
    final stacked = screenWidth < 1200 || available < (_minPanelWidth * 2) + _minCanvasWidth;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuilderToolbar(
              onSave: notifier.save,
              savePayloadVariant: state.savePayloadVariant,
              onSavePayloadVariantChanged: notifier.setSavePayloadVariant,
              onPreview: () => notifier.setPreviewMode(!state.previewMode),
              onUndo: notifier.undo,
              onRedo: notifier.redo,
              onClear: notifier.clearCanvas,
              onUnselectAll: notifier.clearSelection,
              onSelectAll: notifier.selectAllElements,
              onInvertSelection: notifier.invertSelection,
              onSelectAllInSection: () {
                final current = notifier.selectedElement?.id;
                if (current != null) {
                  notifier.selectAllInSectionOf(current);
                }
              },
              onMoveSelectedUp: notifier.moveSelectedUp,
              onMoveSelectedDown: notifier.moveSelectedDown,
              onDeleteSelected: notifier.deleteSelectedElements,
              onDuplicateSelected: notifier.duplicateSelectedElements,
              onMoveSelectedToSection: () async {
                final chosen = await _pickTargetSectionDialog(
                  context,
                  'Move selected items',
                  state.sections.map((section) => section.title).toList(growable: false),
                );
                if (chosen != null) {
                  notifier.moveSelectedElementsToSection(chosen);
                }
              },
              onDuplicateSelectedToSection: () async {
                final chosen = await _pickTargetSectionDialog(
                  context,
                  'Duplicate selected items',
                  state.sections.map((section) => section.title).toList(growable: false),
                );
                if (chosen != null) {
                  notifier.duplicateSelectedToSection(chosen);
                }
              },
              onExportJson: notifier.exportJson,
              canUndo: state.canUndo,
              canRedo: state.canRedo,
              canUnselectAll: state.selectedElementIds.isNotEmpty,
              canSelectAll: state.allElements.isNotEmpty && state.selectedElementIds.length != state.allElements.length,
              canInvertSelection: state.allElements.isNotEmpty,
              canSelectAllInSection: notifier.selectedElement != null,
              canMoveSelectedUp: state.selectedElementIds.isNotEmpty,
              canMoveSelectedDown: state.selectedElementIds.isNotEmpty,
              canDeleteSelected: state.selectedElementIds.isNotEmpty,
              canDuplicateSelected: state.selectedElementIds.isNotEmpty,
              canMoveSelectedToSection: state.selectedElementIds.isNotEmpty && state.sections.isNotEmpty,
              canDuplicateSelectedToSection: state.selectedElementIds.isNotEmpty && state.sections.isNotEmpty,
              selectedCount: state.selectedElementIds.length,
              previewMode: state.previewMode,
              totalFields: state.allElements.length,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: stacked
                    ? Column(
                        children: [
                          Expanded(
                            child: _ResizablePanel(
                              title: 'Component Library',
                              collapsed: _leftCollapsed,
                              onToggleCollapsed: () {
                                setState(() {
                                  _leftCollapsed = !_leftCollapsed;
                                });
                                _saveWidths();
                              },
                              child: ComponentLibrary(
                                searchQuery: state.searchQuery,
                                onSearchChanged: notifier.updateSearchQuery,
                                onDragStarted: notifier.startDrag,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 2,
                            child: _ResizablePanel(
                              title: 'Canvas',
                              child: BuilderCanvas(
                                sections: state.sections,
                                selectedId: state.selectedElementId,
                                selectedIds: state.selectedElementIds,
                                previewMode: state.previewMode,
                                onSelect: notifier.selectElement,
                                onToggleSelect: notifier.toggleElementSelection,
                                onDrop: (item, sectionIndex, index) =>
                                    notifier.addElementFromPalette(item, sectionIndex: sectionIndex, index: index),
                                onReorderInSection: notifier.reorderElementInSection,
                                onMoveElementsToSection: (ids, sectionIndex, targetIndex) =>
                                    notifier.moveElementsToSection(
                                  ids,
                                  sectionIndex,
                                  targetIndex: targetIndex,
                                ),
                                onMoveElementToSection: (elementId, sectionIndex, targetIndex) =>
                                    notifier.moveElementToSection(
                                  elementId,
                                  sectionIndex,
                                  targetIndex: targetIndex,
                                ),
                                onDeleteSection: notifier.removeSection,
                                onDeleteElement: notifier.removeElement,
                                onAddSection: notifier.addSection,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: _ResizablePanel(
                              title: propertiesTitle,
                              child: PropertiesPanel(
                                element: selected,
                                selectedCount: state.selectedElementIds.length,
                                sectionSummaries: sectionSummaries,
                                canMoveSelectedToSection: state.selectedElementIds.isNotEmpty && state.sections.isNotEmpty,
                                onClearSelection: notifier.clearSelection,
                                onSelectAll: notifier.selectAllElements,
                                onInvertSelection: notifier.invertSelection,
                                onDeleteSelected: notifier.deleteSelectedElements,
                                onDuplicateSelected: notifier.duplicateSelectedElements,
                                onMoveSelectedToSection: () async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.moveSelectedElementsToSection(chosen);
                                  }
                                },
                                onSelectSection: (sectionIndex) {
                                  notifier.selectAllInSection(sectionIndex);
                                },
                                onMoveFromSection: (sectionIndex) async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.moveSelectedElementsFromSectionToSection(sectionIndex, chosen);
                                  }
                                },
                                onSelectSectionAndMove: (sectionIndex) async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.selectAndMoveSection(sectionIndex, chosen);
                                  }
                                },
                                onReorderSection: notifier.reorderSection,
                                onChanged: (element) => notifier.updateElement(element.id, element),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          SizedBox(
                            width: leftWidth,
                            child: _ResizablePanel(
                              title: 'Component Library',
                              collapsed: _leftCollapsed,
                              onToggleCollapsed: () {
                                setState(() {
                                  _leftCollapsed = !_leftCollapsed;
                                });
                                _saveWidths();
                              },
                              child: ComponentLibrary(
                                searchQuery: state.searchQuery,
                                onSearchChanged: notifier.updateSearchQuery,
                                onDragStarted: notifier.startDrag,
                              ),
                            ),
                          ),
                          _ResizeHandle(
                            onDragUpdate: (delta) {
                              setState(() {
                                _leftWidth = (_leftWidth + delta).clamp(_minPanelWidth, maxSideWidth).toDouble();
                                _leftCollapsed = false;
                              });
                              _saveWidths();
                            },
                          ),
                          SizedBox(
                            width: canvasWidth,
                            child: _ResizablePanel(
                              title: 'Canvas',
                              showToggle: false,
                              child: BuilderCanvas(
                                sections: state.sections,
                                selectedId: state.selectedElementId,
                                selectedIds: state.selectedElementIds,
                                previewMode: state.previewMode,
                                onSelect: notifier.selectElement,
                                onToggleSelect: notifier.toggleElementSelection,
                                onDrop: (item, sectionIndex, index) =>
                                    notifier.addElementFromPalette(item, sectionIndex: sectionIndex, index: index),
                                onReorderInSection: notifier.reorderElementInSection,
                                onMoveElementsToSection: (ids, sectionIndex, targetIndex) =>
                                    notifier.moveElementsToSection(
                                  ids,
                                  sectionIndex,
                                  targetIndex: targetIndex,
                                ),
                                onMoveElementToSection: (elementId, sectionIndex, targetIndex) =>
                                    notifier.moveElementToSection(
                                  elementId,
                                  sectionIndex,
                                  targetIndex: targetIndex,
                                ),
                                onDeleteSection: notifier.removeSection,
                                onDeleteElement: notifier.removeElement,
                                onAddSection: notifier.addSection,
                              ),
                            ),
                          ),
                          _ResizeHandle(
                            onDragUpdate: (delta) {
                              setState(() {
                                _rightWidth = (_rightWidth - delta).clamp(_minPanelWidth, maxSideWidth).toDouble();
                                _rightCollapsed = false;
                              });
                              _saveWidths();
                            },
                          ),
                          SizedBox(
                            width: rightWidth,
                            child: _ResizablePanel(
                              title: propertiesTitle,
                              collapsed: _rightCollapsed,
                              onToggleCollapsed: () {
                                setState(() {
                                  _rightCollapsed = !_rightCollapsed;
                                });
                                _saveWidths();
                              },
                              child: PropertiesPanel(
                                element: selected,
                                selectedCount: state.selectedElementIds.length,
                                sectionSummaries: sectionSummaries,
                                canMoveSelectedToSection: state.selectedElementIds.isNotEmpty && state.sections.isNotEmpty,
                                onClearSelection: notifier.clearSelection,
                                onSelectAll: notifier.selectAllElements,
                                onInvertSelection: notifier.invertSelection,
                                onDeleteSelected: notifier.deleteSelectedElements,
                                onDuplicateSelected: notifier.duplicateSelectedElements,
                                onMoveSelectedToSection: () async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.moveSelectedElementsToSection(chosen);
                                  }
                                },
                                onSelectSection: (sectionIndex) {
                                  notifier.selectAllInSection(sectionIndex);
                                },
                                onMoveFromSection: (sectionIndex) async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.moveSelectedElementsFromSectionToSection(sectionIndex, chosen);
                                  }
                                },
                                onSelectSectionAndMove: (sectionIndex) async {
                                  final chosen = await _pickTargetSectionDialog(
                                    context,
                                    'Move selected items',
                                    state.sections.map((section) => section.title).toList(growable: false),
                                  );
                                  if (chosen != null) {
                                    notifier.selectAndMoveSection(sectionIndex, chosen);
                                  }
                                },
                                onReorderSection: notifier.reorderSection,
                                onChanged: (element) => notifier.updateElement(element.id, element),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            _StatusBar(
              fieldCount: state.allElements.length,
              selectedType: selected?.type ?? 'None',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant FormBuilderPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasLoadedWidths) {
      final screenWidth = MediaQuery.maybeSizeOf(context)?.width;
      if (screenWidth != null) {
        final available = screenWidth - 32 - (_gutterWidth * 2);
        final maxSideWidth = ((available - _minCanvasWidth) / 2).clamp(_minPanelWidth, 520.0);
        final leftWidth = _leftWidth.clamp(_minPanelWidth, maxSideWidth).toDouble();
        final rightWidth = _rightWidth.clamp(_minPanelWidth, maxSideWidth).toDouble();
        final needsResize = leftWidth != _leftWidth || rightWidth != _rightWidth;
        final needsCollapseReset = (_leftCollapsed && leftWidth <= 0) || (_rightCollapsed && rightWidth <= 0);
        if (needsResize || needsCollapseReset) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _leftWidth = leftWidth;
              _rightWidth = rightWidth;
            });
            _saveWidths();
          });
        }
      }
    }
  }
}

class _ResizeHandle extends StatelessWidget {
  const _ResizeHandle({required this.onDragUpdate});

  final ValueChanged<double> onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) => onDragUpdate(details.delta.dx),
        child: SizedBox(
          width: 10,
          child: Center(
            child: Container(
              width: 2,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResizablePanel extends StatelessWidget {
  const _ResizablePanel({
    required this.title,
    required this.child,
    this.collapsed = false,
    this.onToggleCollapsed,
    this.showToggle = true,
  });

  final String title;
  final Widget child;
  final bool collapsed;
  final VoidCallback? onToggleCollapsed;
  final bool showToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            SizedBox(
              height: collapsed ? 44 : 64,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: collapsed ? 4 : 16, vertical: collapsed ? 2 : 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                ),
                child: collapsed
                    ? Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                          tooltip: 'Expand panel',
                          onPressed: onToggleCollapsed,
                          iconSize: 16,
                          icon: const Icon(Icons.add),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (showToggle)
                            IconButton(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                              tooltip: 'Collapse panel',
                              onPressed: onToggleCollapsed,
                              iconSize: 16,
                              icon: const Icon(Icons.remove),
                            ),
                        ],
                      ),
              ),
            ),
            if (collapsed)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(child: Padding(padding: const EdgeInsets.all(16), child: child)),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.fieldCount, required this.selectedType});

  final int fieldCount;
  final String selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300)), color: Colors.white),
      child: Row(
        children: [
          Text('Fields: $fieldCount'),
          const SizedBox(width: 16),
          Text('Selected: $selectedType'),
        ],
      ),
    );
  }
}
