import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/form_builder_selector_page.dart';
import 'pages/form_builder_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BuilderApp()));
}

class BuilderApp extends StatelessWidget {
  const BuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF121218),
        brightness: Brightness.light,
        surface: const Color(0xFFF7F7F8),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A.D.I.Y.O.G.I',
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
        textTheme: base.textTheme.apply(
          fontFamilyFallback: const ['Instrument Sans', 'Inter', 'sans-serif'],
        ).copyWith(
          displayLarge: base.textTheme.displayLarge?.copyWith(
            fontFamilyFallback: const ['Lora', 'serif'],
          ),
          displayMedium: base.textTheme.displayMedium?.copyWith(
            fontFamilyFallback: const ['Lora', 'serif'],
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontFamilyFallback: const ['Lora', 'serif'],
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7F8),
          foregroundColor: Color(0xFF121218),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const FormBuilderSelectorPage(),
    );
  }
}

class LegacyBuilderRoute extends StatelessWidget {
  const LegacyBuilderRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormBuilderPage();
  }
}
