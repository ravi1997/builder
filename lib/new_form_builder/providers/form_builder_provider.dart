import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form_theme_config.dart';
import '../models/form_layout_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';

class FormBuilderState {
  final FormThemeConfig themeConfig;
  final FormLayoutConfig layoutConfig;
  final AnimationConfig animConfig;
  final ComponentStyleConfig componentConfig;
  final String selectedLayoutId;
  final String selectedCategory;
  final String searchQuery;
  final int wizardStep;
  final String activeDesignCategory;
  final String previewMode;
  final bool skeletonMode;
  final Map<String, dynamic> formValues;

  const FormBuilderState({
    required this.themeConfig,
    required this.layoutConfig,
    required this.animConfig,
    required this.componentConfig,
    required this.selectedLayoutId,
    required this.selectedCategory,
    required this.searchQuery,
    required this.wizardStep,
    required this.activeDesignCategory,
    required this.previewMode,
    required this.skeletonMode,
    required this.formValues,
  });

  factory FormBuilderState.initial() {
    return const FormBuilderState(
      themeConfig: FormThemeConfig(),
      layoutConfig: FormLayoutConfig(),
      animConfig: AnimationConfig(),
      componentConfig: ComponentStyleConfig(),
      selectedLayoutId: 'classic',
      selectedCategory: 'All',
      searchQuery: '',
      wizardStep: 1,
      activeDesignCategory: 'theme',
      previewMode: 'Desktop',
      skeletonMode: true,
      formValues: {},
    );
  }

  FormBuilderState copyWith({
    FormThemeConfig? themeConfig,
    FormLayoutConfig? layoutConfig,
    AnimationConfig? animConfig,
    ComponentStyleConfig? componentConfig,
    String? selectedLayoutId,
    String? selectedCategory,
    String? searchQuery,
    int? wizardStep,
    String? activeDesignCategory,
    String? previewMode,
    bool? skeletonMode,
    Map<String, dynamic>? formValues,
  }) {
    return FormBuilderState(
      themeConfig: themeConfig ?? this.themeConfig,
      layoutConfig: layoutConfig ?? this.layoutConfig,
      animConfig: animConfig ?? this.animConfig,
      componentConfig: componentConfig ?? this.componentConfig,
      selectedLayoutId: selectedLayoutId ?? this.selectedLayoutId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      wizardStep: wizardStep ?? this.wizardStep,
      activeDesignCategory: activeDesignCategory ?? this.activeDesignCategory,
      previewMode: previewMode ?? this.previewMode,
      skeletonMode: skeletonMode ?? this.skeletonMode,
      formValues: formValues ?? this.formValues,
    );
  }
}

abstract class FormBuilderCommand {
  FormBuilderState execute(FormBuilderState currentState);
}

class UpdateThemeCommand implements FormBuilderCommand {
  final FormThemeConfig themeConfig;
  const UpdateThemeCommand(this.themeConfig);

  @override
  FormBuilderState execute(FormBuilderState currentState) {
    return currentState.copyWith(themeConfig: themeConfig);
  }
}

class UpdateComponentStyleCommand implements FormBuilderCommand {
  final ComponentStyleConfig componentConfig;
  const UpdateComponentStyleCommand(this.componentConfig);

  @override
  FormBuilderState execute(FormBuilderState currentState) {
    return currentState.copyWith(componentConfig: componentConfig);
  }
}

class UpdateAnimationCommand implements FormBuilderCommand {
  final AnimationConfig animConfig;
  const UpdateAnimationCommand(this.animConfig);

  @override
  FormBuilderState execute(FormBuilderState currentState) {
    return currentState.copyWith(animConfig: animConfig);
  }
}

class UpdateLayoutConfigCommand implements FormBuilderCommand {
  final FormLayoutConfig layoutConfig;
  final String? selectedLayoutId;

  const UpdateLayoutConfigCommand(this.layoutConfig, {this.selectedLayoutId});

  @override
  FormBuilderState execute(FormBuilderState currentState) {
    return currentState.copyWith(
      layoutConfig: layoutConfig,
      selectedLayoutId: selectedLayoutId ?? currentState.selectedLayoutId,
    );
  }
}

class FormBuilderNotifier extends StateNotifier<FormBuilderState> {
  final List<FormBuilderState> _history = [];
  int _historyIndex = 0;

  FormBuilderNotifier() : super(FormBuilderState.initial()) {
    _history.add(state);
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void execute(FormBuilderCommand command) {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    final nextState = command.execute(state);
    _history.add(nextState);
    _historyIndex++;
    state = nextState;
  }

  void undo() {
    if (canUndo) {
      _historyIndex--;
      state = _history[_historyIndex];
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      state = _history[_historyIndex];
    }
  }

  void updateSelectedLayout(String id) {
    state = state.copyWith(selectedLayoutId: id);
  }

  void updateLayoutConfig(FormLayoutConfig config, {String? selectedLayoutId}) {
    execute(
      UpdateLayoutConfigCommand(config, selectedLayoutId: selectedLayoutId),
    );
  }

  void updateSelectedCategory(String cat) {
    state = state.copyWith(selectedCategory: cat);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateWizardStep(int step) {
    state = state.copyWith(wizardStep: step);
  }

  void updateActiveDesignCategory(String category) {
    state = state.copyWith(activeDesignCategory: category);
  }

  void updatePreviewMode(String mode) {
    state = state.copyWith(previewMode: mode);
  }

  void updateSkeletonMode(bool mode) {
    state = state.copyWith(skeletonMode: mode);
  }

  void updateFormValue(String key, dynamic val) {
    final nextValues = Map<String, dynamic>.from(state.formValues);
    nextValues[key] = val;
    state = state.copyWith(formValues: nextValues);
  }
}

final formBuilderProvider =
    StateNotifierProvider<FormBuilderNotifier, FormBuilderState>((ref) {
      return FormBuilderNotifier();
    });

class FormThemeScope extends InheritedWidget {
  final FormThemeConfig themeConfig;
  final ComponentStyleConfig componentConfig;
  final AnimationConfig animConfig;
  final bool skeletonMode;

  const FormThemeScope({
    super.key,
    required this.themeConfig,
    required this.componentConfig,
    required this.animConfig,
    required this.skeletonMode,
    required super.child,
  });

  static FormThemeScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormThemeScope>();
  }

  @override
  bool updateShouldNotify(FormThemeScope oldWidget) {
    return themeConfig != oldWidget.themeConfig ||
        componentConfig != oldWidget.componentConfig ||
        animConfig != oldWidget.animConfig ||
        skeletonMode != oldWidget.skeletonMode;
  }
}
