import 'package:flutter/material.dart';

enum FontStylePreset {
  roboto,
  poppins,
  inter,
  lora,
  instrumentSans,
  systemDefault,
}

enum SpacingPreset {
  compact,
  comfortable,
  spacious,
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
  final String themePreset; // minimal, dark, material, glassmorphism, enterprise, survey, rounded, neumorphism

  // Typography
  final FontStylePreset fontFamily;
  final double titleSize;
  final double sectionSize;
  final double questionSize;
  final double helperSize;
  final FontWeight fontWeight;

  // Spacing
  final double formPadding;
  final double sectionSpacing;
  final double questionSpacing;
  final double inputPadding;
  final double buttonSpacing;
  final SpacingPreset spacingPreset;
  final double borderRadius;

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
    this.fontFamily = FontStylePreset.instrumentSans,
    this.titleSize = 24.0,
    this.sectionSize = 18.0,
    this.questionSize = 14.0,
    this.helperSize = 12.0,
    this.fontWeight = FontWeight.w500,
    this.formPadding = 24.0,
    this.sectionSpacing = 24.0,
    this.questionSpacing = 16.0,
    this.inputPadding = 12.0,
    this.buttonSpacing = 12.0,
    this.spacingPreset = SpacingPreset.comfortable,
    this.borderRadius = 12.0,
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
    double? titleSize,
    double? sectionSize,
    double? questionSize,
    double? helperSize,
    FontWeight? fontWeight,
    double? formPadding,
    double? sectionSpacing,
    double? questionSpacing,
    double? inputPadding,
    double? buttonSpacing,
    SpacingPreset? spacingPreset,
    double? borderRadius,
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
      helperSize: helperSize ?? this.helperSize,
      fontWeight: fontWeight ?? this.fontWeight,
      formPadding: formPadding ?? this.formPadding,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      questionSpacing: questionSpacing ?? this.questionSpacing,
      inputPadding: inputPadding ?? this.inputPadding,
      buttonSpacing: buttonSpacing ?? this.buttonSpacing,
      spacingPreset: spacingPreset ?? this.spacingPreset,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
