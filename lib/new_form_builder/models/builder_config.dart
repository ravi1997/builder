import 'package:flutter/material.dart';

enum FormLayoutType {
  singlePage,
  accordion,
  sectionCards,
  wizard,
  questionPerPage,
  typeform,
  sidebarNav,
  topTabs,
  progressStepper,
  chat,
  drawer,
  modal,
  gridBuilder,
  twoColumn,
  threeColumn,
  reviewSubmit,
}

enum NavigationStyle {
  none,
  nextPrevious,
  topTabs,
  leftSidebar,
  rightSidebar,
  breadcrumb,
  stepIndicator,
  progressBar,
  percentage,
  checklist,
}

enum FontStylePreset {
  system,
  roboto,
  inter,
  poppins,
  serif,
}

enum ShapeStylePreset {
  square,
  slightRounded,
  rounded,
  extraRounded,
  pill,
}

enum CardStylePreset {
  flat,
  border,
  shadow,
  floating,
  glass,
}

enum BorderStylePreset {
  none,
  solid,
  dashed,
}

enum InputStylePreset {
  outlined,
  filled,
  underline,
  floatingLabel,
  rounded,
  compact,
  large,
}

enum InputStatePreset {
  normal,
  focus,
  error,
  disabled,
  success,
}

enum ButtonTypePreset {
  filled,
  outlined,
  text,
  gradient,
  glass,
}

enum PageTransitionPreset {
  none,
  fade,
  slide,
  scale,
  push,
  flip,
}

enum SectionAnimationPreset {
  fadeIn,
  slideUp,
  expand,
  bounce,
}

enum BackgroundStylePreset {
  solid,
  gradient,
  image,
  pattern,
  glassBlur,
}

class FormLayoutConfig {
  final FormLayoutType layoutType;
  final NavigationStyle navStyle;
  final String navPosition; // top, bottom, side
  final Color activeNavColor;
  final Color completedNavColor;
  final bool showNavIcons;

  // Structure
  final int numSections;
  final int questionsPerSection;
  final String arrangement; // vertical, horizontal, grid, cards, compact, spacious

  const FormLayoutConfig({
    this.layoutType = FormLayoutType.singlePage,
    this.navStyle = NavigationStyle.none,
    this.navPosition = 'bottom',
    this.activeNavColor = const Color(0xFF1B1B21),
    this.completedNavColor = const Color(0xFF94979E),
    this.showNavIcons = true,
    this.numSections = 3,
    this.questionsPerSection = 3,
    this.arrangement = 'vertical',
  });

  FormLayoutConfig copyWith({
    FormLayoutType? layoutType,
    NavigationStyle? navStyle,
    String? navPosition,
    Color? activeNavColor,
    Color? completedNavColor,
    bool? showNavIcons,
    int? numSections,
    int? questionsPerSection,
    String? arrangement,
  }) {
    return FormLayoutConfig(
      layoutType: layoutType ?? this.layoutType,
      navStyle: navStyle ?? this.navStyle,
      navPosition: navPosition ?? this.navPosition,
      activeNavColor: activeNavColor ?? this.activeNavColor,
      completedNavColor: completedNavColor ?? this.completedNavColor,
      showNavIcons: showNavIcons ?? this.showNavIcons,
      numSections: numSections ?? this.numSections,
      questionsPerSection: questionsPerSection ?? this.questionsPerSection,
      arrangement: arrangement ?? this.arrangement,
    );
  }
}

class FormThemeConfig {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color cardColor;
  final Color inputColor;
  final Color textColor;
  final Color errorColor;
  final Color successColor;
  final String themePreset; // minimal, dark, material, enterprise, rounded, neumorphism, survey

  // Typography
  final FontStylePreset fontFamily;
  final String titleSize; // small, medium, large
  final String sectionSize; // small, medium, large
  final String questionSize; // small, medium, large
  final String fontWeight; // light, regular, medium, bold

  const FormThemeConfig({
    this.primary = const Color(0xFF1B1B21),
    this.secondary = const Color(0xFF44454C),
    this.accent = const Color(0xFF61646B),
    this.background = const Color(0xFFF7F7F8),
    this.cardColor = const Color(0xFFFFFFFF),
    this.inputColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF121218),
    this.errorColor = const Color(0xFFD32F2F),
    this.successColor = const Color(0xFF388E3C),
    this.themePreset = 'minimal',
    this.fontFamily = FontStylePreset.inter,
    this.titleSize = 'medium',
    this.sectionSize = 'medium',
    this.questionSize = 'medium',
    this.fontWeight = 'medium',
  });

  FormThemeConfig copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    Color? cardColor,
    Color? inputColor,
    Color? textColor,
    Color? errorColor,
    Color? successColor,
    String? themePreset,
    FontStylePreset? fontFamily,
    String? titleSize,
    String? sectionSize,
    String? questionSize,
    String? fontWeight,
  }) {
    return FormThemeConfig(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      cardColor: cardColor ?? this.cardColor,
      inputColor: inputColor ?? this.inputColor,
      textColor: textColor ?? this.textColor,
      errorColor: errorColor ?? this.errorColor,
      successColor: successColor ?? this.successColor,
      themePreset: themePreset ?? this.themePreset,
      fontFamily: fontFamily ?? this.fontFamily,
      titleSize: titleSize ?? this.titleSize,
      sectionSize: sectionSize ?? this.sectionSize,
      questionSize: questionSize ?? this.questionSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}

class SpacingConfig {
  final double formPadding;
  final double sectionSpacing;
  final double questionSpacing;
  final double inputPadding;
  final String preset; // compact, comfortable, spacious, custom

  const SpacingConfig({
    this.formPadding = 24.0,
    this.sectionSpacing = 24.0,
    this.questionSpacing = 16.0,
    this.inputPadding = 12.0,
    this.preset = 'comfortable',
  });

  SpacingConfig copyWith({
    double? formPadding,
    double? sectionSpacing,
    double? questionSpacing,
    double? inputPadding,
    String? preset,
  }) {
    return SpacingConfig(
      formPadding: formPadding ?? this.formPadding,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      questionSpacing: questionSpacing ?? this.questionSpacing,
      inputPadding: inputPadding ?? this.inputPadding,
      preset: preset ?? this.preset,
    );
  }
}

class ShapeStyleConfig {
  final ShapeStylePreset borderRadius;
  final CardStylePreset cardStyle;
  final BorderStylePreset borderStyle;

  const ShapeStyleConfig({
    this.borderRadius = ShapeStylePreset.rounded,
    this.cardStyle = CardStylePreset.border,
    this.borderStyle = BorderStylePreset.solid,
  });

  ShapeStyleConfig copyWith({
    ShapeStylePreset? borderRadius,
    CardStylePreset? cardStyle,
    BorderStylePreset? borderStyle,
  }) {
    return ShapeStyleConfig(
      borderRadius: borderRadius ?? this.borderRadius,
      cardStyle: cardStyle ?? this.cardStyle,
      borderStyle: borderStyle ?? this.borderStyle,
    );
  }
}

class InputStyleConfig {
  final InputStylePreset inputStyle;
  final InputStatePreset inputState;
  final ButtonTypePreset buttonType;
  final String buttonSize; // small, medium, large, fullWidth
  final ShapeStylePreset buttonShape;
  final String buttonHoverAnim; // none, scale, shadow, color

  const InputStyleConfig({
    this.inputStyle = InputStylePreset.outlined,
    this.inputState = InputStatePreset.normal,
    this.buttonType = ButtonTypePreset.filled,
    this.buttonSize = 'medium',
    this.buttonShape = ShapeStylePreset.rounded,
    this.buttonHoverAnim = 'scale',
  });

  InputStyleConfig copyWith({
    InputStylePreset? inputStyle,
    InputStatePreset? inputState,
    ButtonTypePreset? buttonType,
    String? buttonSize,
    ShapeStylePreset? buttonShape,
    String? buttonHoverAnim,
  }) {
    return InputStyleConfig(
      inputStyle: inputStyle ?? this.inputStyle,
      inputState: inputState ?? this.inputState,
      buttonType: buttonType ?? this.buttonType,
      buttonSize: buttonSize ?? this.buttonSize,
      buttonShape: buttonShape ?? this.buttonShape,
      buttonHoverAnim: buttonHoverAnim ?? this.buttonHoverAnim,
    );
  }
}

class AnimationConfig {
  final PageTransitionPreset transition;
  final SectionAnimationPreset sectionAnim;
  final String inputAnim; // none, focusGlow, borderAnim, floatingLabel
  final String speed; // fast, normal, slow

  const AnimationConfig({
    this.transition = PageTransitionPreset.fade,
    this.sectionAnim = SectionAnimationPreset.fadeIn,
    this.inputAnim = 'focusGlow',
    this.speed = 'normal',
  });

  AnimationConfig copyWith({
    PageTransitionPreset? transition,
    SectionAnimationPreset? sectionAnim,
    String? inputAnim,
    String? speed,
  }) {
    return AnimationConfig(
      transition: transition ?? this.transition,
      sectionAnim: sectionAnim ?? this.sectionAnim,
      inputAnim: inputAnim ?? this.inputAnim,
      speed: speed ?? this.speed,
    );
  }
}

class BackgroundStyleConfig {
  final BackgroundStylePreset bgPreset;
  final String direction; // toRight, toBottom, radial
  final double blurAmount;
  final double opacity;
  final Color solidColor;
  final List<Color> gradientColors;

  const BackgroundStyleConfig({
    this.bgPreset = BackgroundStylePreset.solid,
    this.direction = 'toBottom',
    this.blurAmount = 8.0,
    this.opacity = 1.0,
    this.solidColor = const Color(0xFFF7F7F8),
    this.gradientColors = const [Color(0xFFEDEEF1), Color(0xFFF7F7F8)],
  });

  BackgroundStyleConfig copyWith({
    BackgroundStylePreset? bgPreset,
    String? direction,
    double? blurAmount,
    double? opacity,
    Color? solidColor,
    List<Color>? gradientColors,
  }) {
    return BackgroundStyleConfig(
      bgPreset: bgPreset ?? this.bgPreset,
      direction: direction ?? this.direction,
      blurAmount: blurAmount ?? this.blurAmount,
      opacity: opacity ?? this.opacity,
      solidColor: solidColor ?? this.solidColor,
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }
}
