import 'package:flutter/material.dart';

enum SavePayloadVariant {
  project,
  form,
  section,
  question,
  version,
}

class BuilderToolbar extends StatelessWidget {
  const BuilderToolbar({
    super.key,
    required this.onSave,
    required this.savePayloadVariant,
    required this.onSavePayloadVariantChanged,
    required this.onPreview,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.onUnselectAll,
    required this.onSelectAll,
    required this.onInvertSelection,
    required this.onSelectAllInSection,
    required this.onMoveSelectedUp,
    required this.onMoveSelectedDown,
    required this.onDeleteSelected,
    required this.onDuplicateSelected,
    required this.onMoveSelectedToSection,
    required this.onDuplicateSelectedToSection,
    required this.onExportJson,
    required this.canUndo,
    required this.canRedo,
    required this.canUnselectAll,
    required this.canSelectAll,
    required this.canInvertSelection,
    required this.canSelectAllInSection,
    required this.canMoveSelectedUp,
    required this.canMoveSelectedDown,
    required this.canDeleteSelected,
    required this.canDuplicateSelected,
    required this.canMoveSelectedToSection,
    required this.canDuplicateSelectedToSection,
    required this.selectedCount,
    required this.previewMode,
    required this.totalFields,
  });

  final VoidCallback onSave;
  final SavePayloadVariant savePayloadVariant;
  final ValueChanged<SavePayloadVariant> onSavePayloadVariantChanged;
  final VoidCallback onPreview;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;
  final VoidCallback onUnselectAll;
  final VoidCallback onSelectAll;
  final VoidCallback onInvertSelection;
  final VoidCallback onSelectAllInSection;
  final VoidCallback onMoveSelectedUp;
  final VoidCallback onMoveSelectedDown;
  final VoidCallback onDeleteSelected;
  final VoidCallback onDuplicateSelected;
  final VoidCallback onMoveSelectedToSection;
  final VoidCallback onDuplicateSelectedToSection;
  final VoidCallback onExportJson;
  final bool canUndo;
  final bool canRedo;
  final bool canUnselectAll;
  final bool canSelectAll;
  final bool canInvertSelection;
  final bool canSelectAllInSection;
  final bool canMoveSelectedUp;
  final bool canMoveSelectedDown;
  final bool canDeleteSelected;
  final bool canDuplicateSelected;
  final bool canMoveSelectedToSection;
  final bool canDuplicateSelectedToSection;
  final int selectedCount;
  final bool previewMode;
  final int totalFields;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'A.D.I.Y.O.G.I Builder',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 16),
          Text('Fields: $totalFields', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(width: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(value: false, label: Text('Edit'), icon: Icon(Icons.edit_outlined)),
              ButtonSegment<bool>(value: true, label: Text('Preview'), icon: Icon(Icons.visibility_outlined)),
            ],
            selected: {previewMode},
            onSelectionChanged: (_) => onPreview(),
          ),
          const SizedBox(width: 16),
          FilledButton.tonalIcon(onPressed: canUndo ? onUndo : null, icon: const Icon(Icons.undo), label: const Text('Undo')),
          FilledButton.tonalIcon(onPressed: canRedo ? onRedo : null, icon: const Icon(Icons.redo), label: const Text('Redo')),
          DropdownButtonHideUnderline(
            child: DropdownButton<SavePayloadVariant>(
              value: savePayloadVariant,
              borderRadius: BorderRadius.circular(14),
              items: const [
                DropdownMenuItem(value: SavePayloadVariant.project, child: Text('Project')),
                DropdownMenuItem(value: SavePayloadVariant.form, child: Text('Form')),
                DropdownMenuItem(value: SavePayloadVariant.section, child: Text('Section')),
                DropdownMenuItem(value: SavePayloadVariant.question, child: Text('Question')),
                DropdownMenuItem(value: SavePayloadVariant.version, child: Text('Version')),
              ],
              onChanged: (value) {
                if (value != null) onSavePayloadVariantChanged(value);
              },
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Bulk actions',
            offset: const Offset(0, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (value) {
              switch (value) {
                case 'select_all_in_section':
                  onSelectAllInSection();
                  break;
                case 'move_up':
                  onMoveSelectedUp();
                  break;
                case 'move_down':
                  onMoveSelectedDown();
                  break;
                case 'delete_selected':
                  onDeleteSelected();
                  break;
                case 'duplicate_selected':
                  onDuplicateSelected();
                  break;
                case 'move_selected':
                  onMoveSelectedToSection();
                  break;
                case 'duplicate_to_section':
                  onDuplicateSelectedToSection();
                  break;
                case 'select_all':
                  onSelectAll();
                  break;
                case 'unselect_all':
                  onUnselectAll();
                  break;
                case 'invert':
                  onInvertSelection();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                enabled: false,
                child: Text('Selection'),
              ),
              PopupMenuItem<String>(
                value: 'select_all_in_section',
                enabled: canSelectAllInSection,
                child: Row(
                  children: const [
                    Icon(Icons.view_list, size: 18),
                    SizedBox(width: 10),
                    Text('Select All in Section'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'duplicate_selected',
                enabled: canDuplicateSelected,
                child: Row(
                  children: const [
                    Icon(Icons.copy, size: 18),
                    SizedBox(width: 10),
                    Text('Duplicate Selected'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'move_selected',
                enabled: canMoveSelectedToSection,
                child: Row(
                  children: const [
                    Icon(Icons.drive_file_move, size: 18),
                    SizedBox(width: 10),
                    Text('Move Selected to Section'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'duplicate_to_section',
                enabled: canDuplicateSelectedToSection,
                child: Row(
                  children: const [
                    Icon(Icons.drive_file_move, size: 18),
                    SizedBox(width: 10),
                    Text('Duplicate to Another Section'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete_selected',
                enabled: canDeleteSelected,
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline, size: 18),
                    SizedBox(width: 10),
                    Text('Delete Selected'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'select_all',
                enabled: canSelectAll,
                child: Row(
                  children: const [
                    Icon(Icons.select_all, size: 18),
                    SizedBox(width: 10),
                    Text('Select All'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'unselect_all',
                enabled: canUnselectAll,
                child: Row(
                  children: const [
                    Icon(Icons.deselect, size: 18),
                    SizedBox(width: 10),
                    Text('Unselect All'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'move_up',
                enabled: canMoveSelectedUp,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_upward, size: 18),
                    SizedBox(width: 10),
                    Text('Move Selected Up'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'move_down',
                enabled: canMoveSelectedDown,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_downward, size: 18),
                    SizedBox(width: 10),
                    Text('Move Selected Down'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'invert',
                enabled: canInvertSelection,
                child: Row(
                  children: const [
                    Icon(Icons.swap_horiz, size: 18),
                    SizedBox(width: 10),
                    Text('Invert Selection'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.filter_list, size: 18),
                  SizedBox(width: 8),
                  Text('Bulk Actions'),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$selectedCount selected',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          FilledButton.tonalIcon(onPressed: onClear, icon: const Icon(Icons.clear_all), label: const Text('Clear Canvas')),
          OutlinedButton.icon(onPressed: onExportJson, icon: const Icon(Icons.code), label: const Text('Export JSON')),
          FilledButton.icon(onPressed: onSave, icon: const Icon(Icons.save), label: const Text('Save')),
        ],
      ),
    );
  }
}
