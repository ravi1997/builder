import 'package:builder/domain/adapters/adapters.dart';
import 'package:builder/new_form_builder/models/animation_config.dart';
import 'package:builder/new_form_builder/models/component_style_config.dart';
import 'package:builder/new_form_builder/models/form_layout_config.dart';
import 'package:builder/new_form_builder/models/form_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('design builder configs round-trip through a CollectionExperience', () {
    const theme = FormThemeConfig(
      primary: Color(0xFF112233),
      themePreset: 'enterprise',
      backgroundPreset: BackgroundPreset.mesh,
      fontFamily: FontStylePreset.lora,
      titleSize: 30.0,
      fontWeight: FontWeight.w700,
    );
    const layout = FormLayoutConfig(
      layoutType: FormLayoutType.wizardSection,
      navigationStyle: NavigationStyle.leftSidebar,
      columns: 2,
    );
    const animation = AnimationConfig(
      transition: PageTransitionPreset.slide,
      duration: Duration(milliseconds: 450),
    );
    const component = ComponentStyleConfig(
      inputStyle: InputStylePreset.filled,
      shadowLevel: ShadowPreset.large,
    );

    final experience = DesignPresentationAdapter.toCollectionExperience(
      id: 'experience-1',
      theme: theme,
      layout: layout,
      animation: animation,
      component: component,
    );

    final restoredTheme = DesignPresentationAdapter.themeFromPresentation(
      experience.presentation,
    );
    final restoredLayout = DesignPresentationAdapter.layoutFromPresentation(
      experience.presentation,
    );
    final restoredAnimation = DesignPresentationAdapter.animationFromPresentation(
      experience.presentation,
    );
    final restoredComponent = DesignPresentationAdapter.componentFromPresentation(
      experience.presentation,
    );

    expect(restoredTheme.primary.toARGB32(), theme.primary.toARGB32());
    expect(restoredTheme.themePreset, 'enterprise');
    expect(restoredTheme.backgroundPreset, BackgroundPreset.mesh);
    expect(restoredTheme.fontFamily, FontStylePreset.lora);
    expect(restoredTheme.titleSize, 30.0);
    expect(restoredTheme.fontWeight, FontWeight.w700);

    expect(restoredLayout.layoutType, FormLayoutType.wizardSection);
    expect(restoredLayout.navigationStyle, NavigationStyle.leftSidebar);
    expect(restoredLayout.columns, 2);

    expect(restoredAnimation.transition, PageTransitionPreset.slide);
    expect(restoredAnimation.duration, const Duration(milliseconds: 450));

    expect(restoredComponent.inputStyle, InputStylePreset.filled);
    expect(restoredComponent.shadowLevel, ShadowPreset.large);
  });

  test('presentation getters fall back to defaults when the slice is missing', () {
    expect(DesignPresentationAdapter.themeFromPresentation(const {}).themePreset, 'minimal');
    expect(
      DesignPresentationAdapter.layoutFromPresentation(const {}).layoutType,
      FormLayoutType.classic,
    );
    expect(
      DesignPresentationAdapter.animationFromPresentation(const {}).transition,
      PageTransitionPreset.fade,
    );
    expect(
      DesignPresentationAdapter.componentFromPresentation(const {}).inputStyle,
      InputStylePreset.outlined,
    );
  });
}
