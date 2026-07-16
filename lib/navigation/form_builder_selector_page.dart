import 'package:flutter/material.dart';

import '../pages/form_builder_page.dart';
import '../new_form_builder/pages/new_form_builder_page.dart';

class FormBuilderSelectorPage extends StatelessWidget {
  const FormBuilderSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Form Studio Selector', textAlign: TextAlign.center, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text('Open the legacy builder or the new design-system showcase.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const FormBuilderPage(),
                        ),
                      );
                    },
                    child: const Text('Open Existing Builder'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const NewFormBuilderPage(),
                        ),
                      );
                    },
                    child: const Text('Open New Design Page'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
