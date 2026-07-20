import 'package:flutter/material.dart';

import '../../new_form_builder/models/animation_config.dart';
import '../../new_form_builder/models/component_style_config.dart';
import '../../new_form_builder/models/form_layout_config.dart';
import '../../new_form_builder/models/form_theme_config.dart';
import '../collection/collection_experience.dart';
import '../versioning/artifact_version.dart';

/// Maps the new design/presentation builder
/// (`lib/new_form_builder/providers/form_builder_provider.dart` and its
/// theme/layout/animation/component-style models) onto the `presentation`
/// slice of a [CollectionExperience], per Domain Specification v0.1
/// section 4 and section 11.
///
/// The design builder never owns `schema` (question/section structure) —
/// that stays with [LegacyStructureAdapter]. Both adapters read/write
/// different slices of the same [CollectionExperience] id, which is how the
/// two builders converge on one domain aggregate without merging UIs
/// (section 11).
class DesignPresentationAdapter {
  const DesignPresentationAdapter._();

  static Map<String, dynamic> presentationFromConfigs({
    required FormThemeConfig theme,
    required FormLayoutConfig layout,
    required AnimationConfig animation,
    required ComponentStyleConfig component,
  }) =>
      <String, dynamic>{
        'theme': _themeToJson(theme),
        'layout': _layoutToJson(layout),
        'animation': _animationToJson(animation),
        'component': _componentToJson(component),
      };

  static FormThemeConfig themeFromPresentation(Map<String, dynamic> presentation) {
    final json = presentation['theme'] as Map<String, dynamic>?;
    return json == null ? const FormThemeConfig() : _themeFromJson(json);
  }

  static FormLayoutConfig layoutFromPresentation(Map<String, dynamic> presentation) {
    final json = presentation['layout'] as Map<String, dynamic>?;
    return json == null ? const FormLayoutConfig() : _layoutFromJson(json);
  }

  static AnimationConfig animationFromPresentation(Map<String, dynamic> presentation) {
    final json = presentation['animation'] as Map<String, dynamic>?;
    return json == null ? const AnimationConfig() : _animationFromJson(json);
  }

  static ComponentStyleConfig componentFromPresentation(
    Map<String, dynamic> presentation,
  ) {
    final json = presentation['component'] as Map<String, dynamic>?;
    return json == null ? const ComponentStyleConfig() : _componentFromJson(json);
  }

  /// Builds a [CollectionExperience] carrying only the presentation slice.
  /// `schema`/`validation`/`sourceMappings` are left to the structure
  /// adapter so this adapter stays scoped to presentation only.
  static CollectionExperience toCollectionExperience({
    required String id,
    required FormThemeConfig theme,
    required FormLayoutConfig layout,
    required AnimationConfig animation,
    required ComponentStyleConfig component,
    ArtifactVersion? version,
    Map<String, dynamic> schema = const <String, dynamic>{},
    Map<String, dynamic> validation = const <String, dynamic>{},
    Map<String, dynamic> sourceMappings = const <String, dynamic>{},
  }) {
    return CollectionExperience(
      id: id,
      type: CollectionExperienceType.form,
      version: version ?? ArtifactVersion(id: '${id}_v1'),
      schema: schema,
      presentation: presentationFromConfigs(
        theme: theme,
        layout: layout,
        animation: animation,
        component: component,
      ),
      validation: validation,
      sourceMappings: sourceMappings,
    );
  }

  static Map<String, dynamic> _themeToJson(FormThemeConfig config) => <String, dynamic>{
        'primary': config.primary.toARGB32(),
        'secondary': config.secondary.toARGB32(),
        'accent': config.accent.toARGB32(),
        'background': config.background.toARGB32(),
        'card_color': config.cardColor.toARGB32(),
        'input_color': config.inputColor.toARGB32(),
        'text_color': config.textColor.toARGB32(),
        'error_color': config.errorColor.toARGB32(),
        'success_color': config.successColor.toARGB32(),
        'theme_preset': config.themePreset,
        'background_preset': config.backgroundPreset.name,
        'form_width_preset': config.formWidthPreset.name,
        'font_family': config.fontFamily.name,
        'title_size': config.titleSize,
        'section_size': config.sectionSize,
        'question_size': config.questionSize,
        'helper_size': config.helperSize,
        'font_weight': config.fontWeight.value,
        'form_padding': config.formPadding,
        'section_spacing': config.sectionSpacing,
        'question_spacing': config.questionSpacing,
        'input_padding': config.inputPadding,
        'button_spacing': config.buttonSpacing,
        'spacing_preset': config.spacingPreset.name,
        'border_radius': config.borderRadius,
      };

  static FormThemeConfig _themeFromJson(Map<String, dynamic> json) => FormThemeConfig(
        primary: _color(json['primary']) ?? const FormThemeConfig().primary,
        secondary: _color(json['secondary']) ?? const FormThemeConfig().secondary,
        accent: _color(json['accent']) ?? const FormThemeConfig().accent,
        background: _color(json['background']) ?? const FormThemeConfig().background,
        cardColor: _color(json['card_color']) ?? const FormThemeConfig().cardColor,
        inputColor: _color(json['input_color']) ?? const FormThemeConfig().inputColor,
        textColor: _color(json['text_color']) ?? const FormThemeConfig().textColor,
        errorColor: _color(json['error_color']) ?? const FormThemeConfig().errorColor,
        successColor: _color(json['success_color']) ?? const FormThemeConfig().successColor,
        themePreset: json['theme_preset'] as String? ?? 'minimal',
        backgroundPreset: _enumByName(
          BackgroundPreset.values,
          json['background_preset'],
          BackgroundPreset.solid,
        ),
        formWidthPreset: _enumByName(
          FormWidthPreset.values,
          json['form_width_preset'],
          FormWidthPreset.medium,
        ),
        fontFamily: _enumByName(
          FontStylePreset.values,
          json['font_family'],
          FontStylePreset.instrumentSans,
        ),
        titleSize: (json['title_size'] as num?)?.toDouble() ?? 24.0,
        sectionSize: (json['section_size'] as num?)?.toDouble() ?? 18.0,
        questionSize: (json['question_size'] as num?)?.toDouble() ?? 14.0,
        helperSize: (json['helper_size'] as num?)?.toDouble() ?? 12.0,
        fontWeight: _fontWeight(json['font_weight']) ?? FontWeight.w500,
        formPadding: (json['form_padding'] as num?)?.toDouble() ?? 24.0,
        sectionSpacing: (json['section_spacing'] as num?)?.toDouble() ?? 24.0,
        questionSpacing: (json['question_spacing'] as num?)?.toDouble() ?? 16.0,
        inputPadding: (json['input_padding'] as num?)?.toDouble() ?? 12.0,
        buttonSpacing: (json['button_spacing'] as num?)?.toDouble() ?? 12.0,
        spacingPreset: _enumByName(
          SpacingPreset.values,
          json['spacing_preset'],
          SpacingPreset.comfortable,
        ),
        borderRadius: (json['border_radius'] as num?)?.toDouble() ?? 12.0,
      );

  static Map<String, dynamic> _layoutToJson(FormLayoutConfig config) => <String, dynamic>{
        'presentation_mode': config.presentationMode.name,
        'navigation_style': config.navigationStyle.name,
        'arrangement_mode': config.arrangementMode.name,
        'logic_mode': config.logicMode.name,
        'layout_type': config.layoutType.name,
        'nav_style': config.navStyle.name,
        'columns': config.columns,
        'num_sections': config.numSections,
        'questions_per_section': config.questionsPerSection,
      };

  static FormLayoutConfig _layoutFromJson(Map<String, dynamic> json) => FormLayoutConfig(
        presentationMode: _enumByName(
          PresentationMode.values,
          json['presentation_mode'],
          PresentationMode.page,
        ),
        navigationStyle: _enumByName(
          NavigationStyle.values,
          json['navigation_style'],
          NavigationStyle.scroll,
        ),
        arrangementMode: _enumByName(
          ArrangementMode.values,
          json['arrangement_mode'],
          ArrangementMode.stack,
        ),
        logicMode: _enumByName(LogicMode.values, json['logic_mode'], LogicMode.linear),
        layoutType: _enumByName(
          FormLayoutType.values,
          json['layout_type'],
          FormLayoutType.classic,
        ),
        navStyle: _enumByName(NavigationStyle.values, json['nav_style'], NavigationStyle.none),
        columns: json['columns'] as int? ?? 1,
        numSections: json['num_sections'] as int? ?? 3,
        questionsPerSection: json['questions_per_section'] as int? ?? 3,
      );

  static Map<String, dynamic> _animationToJson(AnimationConfig config) => <String, dynamic>{
        'transition': config.transition.name,
        'section_anim': config.sectionAnim.name,
        'input_anim': config.inputAnim.name,
        'duration_ms': config.duration.inMilliseconds,
        'curve': config.curve.name,
      };

  static AnimationConfig _animationFromJson(Map<String, dynamic> json) => AnimationConfig(
        transition: _enumByName(
          PageTransitionPreset.values,
          json['transition'],
          PageTransitionPreset.fade,
        ),
        sectionAnim: _enumByName(
          SectionAnimationPreset.values,
          json['section_anim'],
          SectionAnimationPreset.fadeIn,
        ),
        inputAnim: _enumByName(
          InputAnimationPreset.values,
          json['input_anim'],
          InputAnimationPreset.focusGlow,
        ),
        duration: Duration(milliseconds: json['duration_ms'] as int? ?? 300),
        curve: _enumByName(
          AnimationCurvePreset.values,
          json['curve'],
          AnimationCurvePreset.ease,
        ),
      );

  static Map<String, dynamic> _componentToJson(ComponentStyleConfig config) => <String, dynamic>{
        'input_style': config.inputStyle.name,
        'card_style': config.cardStyle.name,
        'button_style': config.buttonStyle.name,
        'border_style': config.borderStyle.name,
        'shadow_level': config.shadowLevel.name,
      };

  static ComponentStyleConfig _componentFromJson(Map<String, dynamic> json) =>
      ComponentStyleConfig(
        inputStyle: _enumByName(
          InputStylePreset.values,
          json['input_style'],
          InputStylePreset.outlined,
        ),
        cardStyle: _enumByName(CardStylePreset.values, json['card_style'], CardStylePreset.border),
        buttonStyle: _enumByName(
          ButtonStylePreset.values,
          json['button_style'],
          ButtonStylePreset.filled,
        ),
        borderStyle: _enumByName(
          BorderStylePreset.values,
          json['border_style'],
          BorderStylePreset.thin,
        ),
        shadowLevel: _enumByName(ShadowPreset.values, json['shadow_level'], ShadowPreset.small),
      );

  static T _enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
    if (name is! String) return fallback;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return fallback;
  }

  static Color? _color(Object? value) => value is int ? Color(value) : null;

  static FontWeight? _fontWeight(Object? value) {
    if (value is! int) return null;
    for (final weight in FontWeight.values) {
      if (weight.value == value) return weight;
    }
    return null;
  }
}
