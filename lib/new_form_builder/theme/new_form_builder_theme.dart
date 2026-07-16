import 'package:flutter/material.dart';

enum FormBuilderThemePreset { enterprise, dark, creative, minimal }

class NewFormBuilderTheme {
  const NewFormBuilderTheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.mutedText,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    this.radius = 16,
    this.spacing = 16,
    this.preset = FormBuilderThemePreset.enterprise,
  });

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color text;
  final Color mutedText;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final double radius;
  final double spacing;
  final FormBuilderThemePreset preset;

  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFEDEEF1);
  static const Color surfaceWhite = Color(0xFFF7F7F8);
  static const Color charcoal = Color(0xFF1B1B21);
  static const Color greyBody = Color(0xFF61646B);
  static const Color greyMuted = Color(0xFF94979E);
  static const Color inkBlack = Color(0xFF121218);
  static const Color slateMid = Color(0xFF44454C);
  static const Color borderLight = Color(0xFFC9CDD2);

  static NewFormBuilderTheme presetTheme(FormBuilderThemePreset preset) {
    switch (preset) {
      case FormBuilderThemePreset.dark:
        return const NewFormBuilderTheme(
          preset: FormBuilderThemePreset.dark,
          primary: charcoal,
          secondary: slateMid,
          accent: greyBody,
          background: charcoal,
          surface: inkBlack,
          text: surfaceWhite,
          mutedText: greyMuted,
          border: slateMid,
          success: surfaceWhite,
          warning: greyMuted,
          error: inkBlack,
          info: greyBody,
        );
      case FormBuilderThemePreset.creative:
        return const NewFormBuilderTheme(
          preset: FormBuilderThemePreset.creative,
          primary: charcoal,
          secondary: surfaceWhite,
          accent: greyMuted,
          background: surfaceWhite,
          surface: pureWhite,
          text: inkBlack,
          mutedText: greyBody,
          border: borderLight,
          success: charcoal,
          warning: slateMid,
          error: inkBlack,
          info: greyBody,
        );
      case FormBuilderThemePreset.minimal:
        return const NewFormBuilderTheme(
          preset: FormBuilderThemePreset.minimal,
          primary: inkBlack,
          secondary: surfaceWhite,
          accent: greyMuted,
          background: surfaceWhite,
          surface: pureWhite,
          text: inkBlack,
          mutedText: greyMuted,
          border: borderLight,
          success: charcoal,
          warning: slateMid,
          error: inkBlack,
          info: greyBody,
        );
      case FormBuilderThemePreset.enterprise:
        return const NewFormBuilderTheme(
          preset: FormBuilderThemePreset.enterprise,
          primary: inkBlack,
          secondary: surfaceWhite,
          accent: slateMid,
          background: surfaceWhite,
          surface: pureWhite,
          text: inkBlack,
          mutedText: greyMuted,
          border: borderLight,
          success: charcoal,
          warning: slateMid,
          error: inkBlack,
          info: greyBody,
        );
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light().copyWith(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onSurface: text,
      ),
      scaffoldBackgroundColor: background,
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        filled: true,
        fillColor: surface,
        helperStyle: TextStyle(color: mutedText, fontFamily: 'Instrument Sans'),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 56, fontWeight: FontWeight.w600, height: 64 / 56, letterSpacing: -1.12, fontFamily: 'Lora'),
        headlineMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, height: 48 / 36, letterSpacing: -0.72, fontFamily: 'Lora'),
        headlineSmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, height: 48 / 32, fontFamily: 'Lora'),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 30 / 20, letterSpacing: -0.8, fontFamily: 'Instrument Sans'),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 28 / 18, letterSpacing: -0.36, fontFamily: 'Instrument Sans'),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, letterSpacing: -0.32, fontFamily: 'Instrument Sans'),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, letterSpacing: -0.14, fontFamily: 'Instrument Sans'),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, letterSpacing: -0.14, fontFamily: 'Instrument Sans'),
        labelSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 15.6 / 13, fontFamily: 'Inter'),
      ).apply(
        bodyColor: text,
        displayColor: text,
      ),
    );
  }
}
