import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/adapters/legacy_structure_adapter.dart';
import '../domain/project/project.dart';
import '../domain/serialization/collection_experience_serializer.dart';
import '../domain/versioning/artifact_version.dart';
import '../models/form_element.dart';
import '../models/form_section.dart';
import '../utils/backend_payload_builder.dart';
import '../utils/field_registry.dart';
import '../widgets/toolbar.dart';

class FormBuilderState {
  FormBuilderState({
    required this.sections,
    required this.selectedElementId,
    required this.selectedElementIds,
    required this.canUndo,
    required this.canRedo,
    required this.searchQuery,
    required this.dropPreviewIndex,
    required this.draggingType,
    required this.previewMode,
    required this.revision,
    required this.savePayloadVariant,
  });

  factory FormBuilderState.initial() => FormBuilderState(
    sections: [
      FormSection(
        id: 'section_${DateTime.now().microsecondsSinceEpoch}',
        title: 'Section 1',
      ),
    ],
    selectedElementId: null,
    selectedElementIds: const <String>{},
    canUndo: false,
    canRedo: false,
    searchQuery: '',
    dropPreviewIndex: null,
    draggingType: null,
    previewMode: false,
    revision: 0,
    savePayloadVariant: SavePayloadVariant.form,
  );

  final List<FormSection> sections;
  final String? selectedElementId;
  final Set<String> selectedElementIds;
  final bool canUndo;
  final bool canRedo;
  final String searchQuery;
  final int? dropPreviewIndex;
  final String? draggingType;
  final bool previewMode;
  final int revision;
  final SavePayloadVariant savePayloadVariant;

  List<FormElement> get allElements =>
      sections.expand((section) => section.elements).toList(growable: false);

  FormBuilderState copyWith({
    List<FormSection>? sections,
    String? selectedElementId,
    Set<String>? selectedElementIds,
    bool? canUndo,
    bool? canRedo,
    String? searchQuery,
    int? dropPreviewIndex,
    String? draggingType,
    bool? previewMode,
    int? revision,
    SavePayloadVariant? savePayloadVariant,
    bool clearSelectedElementId = false,
    bool clearDropPreviewIndex = false,
    bool clearDraggingType = false,
  }) {
    return FormBuilderState(
      sections: sections ?? this.sections,
      selectedElementId: clearSelectedElementId
          ? null
          : selectedElementId ?? this.selectedElementId,
      selectedElementIds: selectedElementIds ?? this.selectedElementIds,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      searchQuery: searchQuery ?? this.searchQuery,
      dropPreviewIndex: clearDropPreviewIndex
          ? null
          : dropPreviewIndex ?? this.dropPreviewIndex,
      draggingType: clearDraggingType
          ? null
          : draggingType ?? this.draggingType,
      previewMode: previewMode ?? this.previewMode,
      revision: revision ?? this.revision,
      savePayloadVariant: savePayloadVariant ?? this.savePayloadVariant,
    );
  }
}

final formBuilderProvider =
    StateNotifierProvider<FormBuilderNotifier, FormBuilderState>(
      (ref) => FormBuilderNotifier(),
    );

class FormBuilderNotifier extends StateNotifier<FormBuilderState> {
  FormBuilderNotifier() : super(FormBuilderState.initial());

  final List<FormBuilderState> _undoStack = [];
  final List<FormBuilderState> _redoStack = [];

  void updateSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setPreviewMode(bool value) {
    state = state.copyWith(previewMode: value, revision: state.revision + 1);
  }

  void setSavePayloadVariant(SavePayloadVariant variant) {
    state = state.copyWith(
      savePayloadVariant: variant,
      revision: state.revision + 1,
    );
  }

  void startDrag(String type) {
    // Intentionally no-op: mutating state here can rebuild the page and cancel
    // the drag gesture on web before it begins.
    type;
  }

  void updateDropPreview(int? index) {
    state = state.copyWith(dropPreviewIndex: index);
  }

  void clearDropPreview() {
    state = state.copyWith(
      clearDropPreviewIndex: true,
      clearDraggingType: true,
    );
  }

  void selectElement(String? id) {
    state = state.copyWith(
      selectedElementId: id,
      selectedElementIds: id == null ? <String>{} : <String>{id},
    );
  }

  void toggleElementSelection(String id, {bool exclusive = false}) {
    final next = <String>{...state.selectedElementIds};
    if (exclusive) {
      next
        ..clear()
        ..add(id);
    } else if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = state.copyWith(
      selectedElementIds: next,
      selectedElementId: next.isEmpty ? null : next.last,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      clearSelectedElementId: true,
      selectedElementIds: const <String>{},
    );
  }

  void selectAllElements() {
    final ids = state.allElements.map((element) => element.id).toSet();
    state = state.copyWith(
      selectedElementId: ids.isEmpty ? null : ids.last,
      selectedElementIds: ids,
    );
  }

  void invertSelection() {
    final allIds = state.allElements.map((element) => element.id).toSet();
    final next = allIds.difference(state.selectedElementIds);
    state = state.copyWith(
      selectedElementId: next.isEmpty ? null : next.last,
      selectedElementIds: next,
    );
  }

  void deleteSelectedElements() {
    if (state.selectedElementIds.isEmpty) return;
    _commit(
      mutate: () {
        final ids = state.selectedElementIds;
        final sections = _cloneSections();
        for (var i = 0; i < sections.length; i++) {
          final elements = List<FormElement>.from(sections[i].elements)
            ..removeWhere((element) => ids.contains(element.id));
          sections[i] = sections[i].copyWith(elements: elements);
        }
        return sections;
      },
    );
    clearSelection();
  }

  void duplicateSelectedElements() {
    if (state.selectedElementIds.isEmpty) return;
    _commit(
      mutate: () {
        final ids = state.selectedElementIds;
        final sections = _cloneSections();
        final duplicatedIds = <String>{};
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        ) {
          final originalElements = List<FormElement>.from(
            sections[sectionIndex].elements,
          );
          final nextElements = <FormElement>[];
          for (final element in originalElements) {
            nextElements.add(element);
            if (ids.contains(element.id)) {
              final duplicate = element.copyWith(
                id: 'field_${DateTime.now().microsecondsSinceEpoch}_${duplicatedIds.length}',
              );
              duplicatedIds.add(duplicate.id);
              nextElements.add(duplicate);
            }
          }
          sections[sectionIndex] = sections[sectionIndex].copyWith(
            elements: nextElements,
          );
        }
        return sections;
      },
      preserveSelection: true,
    );
  }

  void moveSelectedElementsToSection(
    int targetSectionIndex, {
    int? targetIndex,
  }) {
    if (state.selectedElementIds.isEmpty) return;
    moveElementsToSection(
      state.selectedElementIds.toList(growable: false),
      targetSectionIndex,
      targetIndex: targetIndex,
    );
  }

  void moveSelectedElementsFromSectionToSection(
    int sourceSectionIndex,
    int targetSectionIndex, {
    int? targetIndex,
  }) {
    if (sourceSectionIndex < 0 || sourceSectionIndex >= state.sections.length)
      return;
    final sourceIds = state.sections[sourceSectionIndex].elements
        .where((element) => state.selectedElementIds.contains(element.id))
        .map((element) => element.id)
        .toList(growable: false);
    if (sourceIds.isEmpty) return;
    moveElementsToSection(
      sourceIds,
      targetSectionIndex,
      targetIndex: targetIndex,
    );
  }

  void selectAndMoveSection(int sourceSectionIndex, int targetSectionIndex) {
    selectAllInSection(sourceSectionIndex);
    moveSelectedElementsFromSectionToSection(
      sourceSectionIndex,
      targetSectionIndex,
    );
  }

  void selectAllInSectionOf(String elementId) {
    final sectionIndex = _sectionIndexForElementId(elementId);
    if (sectionIndex == null) return;
    selectAllInSection(sectionIndex);
  }

  void selectAllInSection(int sectionIndex) {
    if (sectionIndex < 0 || sectionIndex >= state.sections.length) return;
    final ids = state.sections[sectionIndex].elements
        .map((element) => element.id)
        .toSet();
    state = state.copyWith(
      selectedElementId: ids.isEmpty ? null : ids.last,
      selectedElementIds: ids,
    );
  }

  void moveSelectedUp() {
    if (state.selectedElementIds.isEmpty) return;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        ) {
          final elements = List<FormElement>.from(
            sections[sectionIndex].elements,
          );
          final selectedIndexes = <int>[];
          for (var i = 0; i < elements.length; i++) {
            if (state.selectedElementIds.contains(elements[i].id)) {
              selectedIndexes.add(i);
            }
          }
          for (final index in selectedIndexes) {
            if (index <= 0) continue;
            final current = elements[index];
            elements[index] = elements[index - 1];
            elements[index - 1] = current;
          }
          sections[sectionIndex] = sections[sectionIndex].copyWith(
            elements: elements,
          );
        }
        return sections;
      },
      preserveSelection: true,
    );
  }

  void moveSelectedDown() {
    if (state.selectedElementIds.isEmpty) return;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        ) {
          final elements = List<FormElement>.from(
            sections[sectionIndex].elements,
          );
          final selectedIndexes = <int>[];
          for (var i = 0; i < elements.length; i++) {
            if (state.selectedElementIds.contains(elements[i].id)) {
              selectedIndexes.add(i);
            }
          }
          for (var i = selectedIndexes.length - 1; i >= 0; i--) {
            final index = selectedIndexes[i];
            if (index >= elements.length - 1) continue;
            final current = elements[index];
            elements[index] = elements[index + 1];
            elements[index + 1] = current;
          }
          sections[sectionIndex] = sections[sectionIndex].copyWith(
            elements: elements,
          );
        }
        return sections;
      },
      preserveSelection: true,
    );
  }

  void duplicateSelectedToSection(int targetSectionIndex) {
    if (state.selectedElementIds.isEmpty) return;
    final selected = state.selectedElementIds;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        while (sections.length <= targetSectionIndex) {
          sections.add(
            FormSection(
              id: 'section_${DateTime.now().microsecondsSinceEpoch}_${sections.length}',
              title: 'Section ${sections.length + 1}',
            ),
          );
        }

        final duplicates = <FormElement>[];
        for (final section in sections) {
          for (final element in section.elements) {
            if (selected.contains(element.id)) {
              duplicates.add(
                element.copyWith(
                  id: 'field_${DateTime.now().microsecondsSinceEpoch}_${duplicates.length}',
                ),
              );
            }
          }
        }

        final targetSection = sections[targetSectionIndex];
        sections[targetSectionIndex] = targetSection.copyWith(
          elements: [...targetSection.elements, ...duplicates],
        );
        return sections;
      },
      preserveSelection: true,
    );
  }

  void addSection() {
    _commit(
      mutate: () {
        final sections = List<FormSection>.from(state.sections);
        sections.add(
          FormSection(
            id: 'section_${DateTime.now().microsecondsSinceEpoch}',
            title: 'Section ${sections.length + 1}',
          ),
        );
        return sections;
      },
    );
  }

  void reorderSection(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= state.sections.length) return;
    if (newIndex < 0 || newIndex > state.sections.length) return;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        if (newIndex > oldIndex) newIndex -= 1;
        final section = sections.removeAt(oldIndex);
        sections.insert(newIndex, section);
        return sections;
      },
      preserveSelection: true,
    );
  }

  void removeSection(int sectionIndex) {
    if (sectionIndex < 0 || sectionIndex >= state.sections.length) return;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        sections.removeAt(sectionIndex);
        if (sections.isEmpty) {
          sections.add(
            FormSection(
              id: 'section_${DateTime.now().microsecondsSinceEpoch}',
              title: 'Section 1',
            ),
          );
        }
        return sections;
      },
      preserveSelection: true,
    );
  }

  void removeElement(String id) {
    _commit(
      mutate: () {
        final sections = _cloneSections();
        for (var i = 0; i < sections.length; i++) {
          final elements = List<FormElement>.from(sections[i].elements)
            ..removeWhere((element) => element.id == id);
          sections[i] = sections[i].copyWith(elements: elements);
        }
        return sections;
      },
      preserveSelection: false,
    );
  }

  void addElementFromPalette(FieldItem item, {int? sectionIndex, int? index}) {
    _commit(
      mutate: () {
        final sections = _cloneSections();
        final targetSectionIndex =
            sectionIndex ?? (sections.isEmpty ? 0 : sections.length - 1);
        while (sections.length <= targetSectionIndex) {
          sections.add(
            FormSection(
              id: 'section_${DateTime.now().microsecondsSinceEpoch}_${sections.length}',
              title: 'Section ${sections.length + 1}',
            ),
          );
        }
        final target = sections[targetSectionIndex];
        final elements = List<FormElement>.from(target.elements);
        final newElement = FormElement(
          id: 'field_${DateTime.now().microsecondsSinceEpoch}',
          type: item.type,
          label: item.label,
          required: false,
          properties: _defaultPropertiesForType(item.type),
        );
        final insertIndex = index == null
            ? elements.length
            : index.clamp(0, elements.length);
        elements.insert(insertIndex, newElement);
        sections[targetSectionIndex] = target.copyWith(elements: elements);
        return sections;
      },
    );
  }

  void reorderElement(int oldIndex, int newIndex) {
    final flat = state.allElements;
    if (oldIndex < 0 ||
        oldIndex >= flat.length ||
        newIndex < 0 ||
        newIndex > flat.length)
      return;
    _commit(
      mutate: () {
        final sections = _cloneSections();
        if (newIndex > oldIndex) newIndex -= 1;
        final item = flat[oldIndex];
        final source = _sectionIndexForElementId(item.id);
        if (source == null) return sections;
        final sourceElements = List<FormElement>.from(
          sections[source].elements,
        );
        sourceElements.removeWhere((element) => element.id == item.id);
        final targetIndex = _sectionIndexForFlatIndex(newIndex, sections);
        final targetSection = sections[targetIndex ?? source];
        final targetElements = List<FormElement>.from(targetSection.elements);
        targetElements.insert(
          (targetIndex == source)
              ? sourceElements.length
              : targetElements.length,
          item,
        );
        sections[source] = sections[source].copyWith(elements: sourceElements);
        sections[targetIndex ?? source] = targetSection.copyWith(
          elements: targetElements,
        );
        return sections;
      },
    );
  }

  void reorderElementInSection(int sectionIndex, int oldIndex, int newIndex) {
    _commit(
      mutate: () {
        final sections = _cloneSections();
        final elements = List<FormElement>.from(
          sections[sectionIndex].elements,
        );
        if (newIndex > oldIndex) newIndex -= 1;
        final item = elements.removeAt(oldIndex);
        elements.insert(newIndex, item);
        sections[sectionIndex] = sections[sectionIndex].copyWith(
          elements: elements,
        );
        return sections;
      },
    );
  }

  void moveElementToSection(
    String elementId,
    int targetSectionIndex, {
    int? targetIndex,
  }) {
    moveElementsToSection(
      [elementId],
      targetSectionIndex,
      targetIndex: targetIndex,
    );
  }

  void moveElementsToSection(
    List<String> elementIds,
    int targetSectionIndex, {
    int? targetIndex,
  }) {
    _commit(
      mutate: () {
        final sections = _cloneSections();
        final ids = elementIds.toSet().toList(growable: false);
        if (ids.isEmpty) return sections;

        final orderedItems = <FormElement>[];
        for (final section in sections) {
          for (final element in section.elements) {
            if (ids.contains(element.id)) {
              orderedItems.add(element);
            }
          }
        }
        if (orderedItems.isEmpty) return sections;

        final sourceSectionIndices = <int>{};
        for (final id in ids) {
          final sourceSectionIndex = _sectionIndexForElementId(id);
          if (sourceSectionIndex != null) {
            sourceSectionIndices.add(sourceSectionIndex);
          }
        }
        for (final sourceSectionIndex in sourceSectionIndices) {
          final sourceElements = List<FormElement>.from(
            sections[sourceSectionIndex].elements,
          );
          sourceElements.removeWhere((element) => ids.contains(element.id));
          sections[sourceSectionIndex] = sections[sourceSectionIndex].copyWith(
            elements: sourceElements,
          );
        }

        while (sections.length <= targetSectionIndex) {
          sections.add(
            FormSection(
              id: 'section_${DateTime.now().microsecondsSinceEpoch}_${sections.length}',
              title: 'Section ${sections.length + 1}',
            ),
          );
        }

        final targetSection = sections[targetSectionIndex];
        final targetElements = List<FormElement>.from(targetSection.elements);
        final insertIndex = targetIndex == null
            ? targetElements.length
            : targetIndex.clamp(0, targetElements.length);
        targetElements.insertAll(insertIndex, orderedItems);
        sections[targetSectionIndex] = targetSection.copyWith(
          elements: targetElements,
        );
        return sections;
      },
      preserveSelection: true,
    );
  }

  void updateElement(String id, FormElement updated) {
    _commit(
      mutate: () {
        final sections = _cloneSections();
        for (var i = 0; i < sections.length; i++) {
          final elements = sections[i].elements
              .map((element) => element.id == id ? updated : element)
              .toList(growable: false);
          sections[i] = sections[i].copyWith(elements: elements);
        }
        return sections;
      },
      preserveSelection: true,
    );
  }

  void clearCanvas() {
    _commit(
      mutate: () => [
        FormSection(
          id: 'section_${DateTime.now().microsecondsSinceEpoch}',
          title: 'Section 1',
        ),
      ],
    );
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(state);
    state = _undoStack.removeLast();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(state);
    state = _redoStack.removeLast();
  }

  void _commit({
    required List<FormSection> Function() mutate,
    bool preserveSelection = false,
  }) {
    _undoStack.add(state);
    _redoStack.clear();
    final next = mutate();
    final nextSelected = preserveSelection
        ? state.selectedElementId
        : _selectedIdFor(next);
    state = state.copyWith(
      sections: next,
      selectedElementId: nextSelected,
      canUndo: _undoStack.isNotEmpty,
      canRedo: _redoStack.isNotEmpty,
      revision: state.revision + 1,
    );
  }

  String? _selectedIdFor(List<FormSection> next) {
    final flat = next.expand((section) => section.elements);
    if (state.selectedElementId != null &&
        flat.any((element) => element.id == state.selectedElementId)) {
      return state.selectedElementId;
    }
    final last = next.lastWhere(
      (section) => section.elements.isNotEmpty,
      orElse: () =>
          next.isEmpty ? FormSection(id: 'tmp', title: 'tmp') : next.last,
    );
    return last.elements.isNotEmpty ? last.elements.last.id : null;
  }

  void exportJson() {
    debugPrint(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(buildBackendSavePreview(variant: state.savePayloadVariant)),
    );
  }

  void save() {
    debugPrint(
      const JsonEncoder.withIndent(
        '  ',
      ).convert(buildBackendSavePreview(variant: state.savePayloadVariant)),
    );
  }

  Map<String, dynamic> buildBackendSavePreview({
    SavePayloadVariant variant = SavePayloadVariant.form,
  }) {
    switch (variant) {
      case SavePayloadVariant.project:
        return CollectionExperienceSerializer.project(
          Project(
            id: 'project-crud-0001',
            name: 'Project CRUD',
            version: ArtifactVersion(id: 'project-v1'),
          ),
        );
      case SavePayloadVariant.form:
        return CollectionExperienceSerializer.form(
          LegacyStructureAdapter.toCollectionExperience(
            id: 'form-crud-0001',
            sections: state.sections,
            version: ArtifactVersion(id: 'form-v1'),
          ),
        );
      case SavePayloadVariant.section:
        return CollectionExperienceSerializer.section(state.sections.first);
      case SavePayloadVariant.question:
        final question =
            selectedElement ??
            (state.allElements.isNotEmpty
                ? state.allElements.first
                : FormElement(
                    id: 'question-nested-0001',
                    type: 'text',
                    label: 'Question',
                    required: false,
                  ));
        return CollectionExperienceSerializer.question(question);
      case SavePayloadVariant.version:
        return CollectionExperienceSerializer.version(
          ArtifactVersion(id: 'entity-v2'),
        );
    }
  }

  FormElement? get selectedElement {
    final id = state.selectedElementId;
    if (id == null) return null;
    for (final element in state.allElements) {
      if (element.id == id) return element;
    }
    return null;
  }

  int? _sectionIndexForElementId(String id) {
    for (var i = 0; i < state.sections.length; i++) {
      if (state.sections[i].elements.any((element) => element.id == id))
        return i;
    }
    return null;
  }

  int? _sectionIndexForFlatIndex(int flatIndex, List<FormSection> sections) {
    var count = 0;
    for (var i = 0; i < sections.length; i++) {
      final nextCount = count + sections[i].elements.length;
      if (flatIndex < nextCount) return i;
      count = nextCount;
    }
    return sections.isEmpty ? null : sections.length - 1;
  }

  List<FormSection> _cloneSections() {
    return state.sections
        .map(
          (section) => section.copyWith(
            elements: List<FormElement>.from(section.elements),
          ),
        )
        .toList(growable: true);
  }

  Map<String, dynamic> _defaultPropertiesForType(String type) {
    final options = <String>['Option 1', 'Option 2', 'Option 3'];
    return <String, dynamic>{
      'description': '',
      'placeholder': 'Enter value',
      'defaultValue': '',
      'validationRules': <String>[],
      if (type == 'dropdown' ||
          type == 'radio' ||
          type == 'checkbox' ||
          type == 'checkbox_group' ||
          type == 'multi_radio' ||
          type == 'multi_choice' ||
          type == 'single_choice')
        'options': options,
      if (type == 'slider') ...<String, dynamic>{
        'min': 0.0,
        'max': 100.0,
        'step': 1.0,
      },
      if (type == 'date') 'range': 'Any date',
      if (type == 'text' ||
          type == 'textarea' ||
          type == 'email' ||
          type == 'phone' ||
          type == 'url') ...<String, dynamic>{'minLength': 0, 'maxLength': 255},
      if (type.contains('number') ||
          type == 'integer' ||
          type == 'decimal' ||
          type == 'currency' ||
          type == 'percentage' ||
          type == 'score') ...<String, dynamic>{'minimum': 0, 'maximum': 100},
    };
  }
}
