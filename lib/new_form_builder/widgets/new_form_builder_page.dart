import 'package:flutter/material.dart';

import '../theme/new_form_builder_theme.dart';

enum DesignLayoutPreset { singlePage, wizard, sidebarNav, cardStack }
enum DesignAnimationPreset { none, fade, slide, scale, expandCollapse }
enum DesignDensityPreset { compact, comfortable, spacious }

class NewFormBuilderPage extends StatefulWidget {
  const NewFormBuilderPage({super.key});

  @override
  State<NewFormBuilderPage> createState() => _NewFormBuilderPageState();
}

class _NewFormBuilderPageState extends State<NewFormBuilderPage> {
  FormBuilderThemePreset _themePreset = FormBuilderThemePreset.enterprise;
  DesignLayoutPreset _layoutPreset = DesignLayoutPreset.singlePage;
  DesignAnimationPreset _animationPreset = DesignAnimationPreset.fade;
  DesignDensityPreset _densityPreset = DesignDensityPreset.comfortable;

  @override
  Widget build(BuildContext context) {
    final theme = NewFormBuilderTheme.presetTheme(_themePreset).toThemeData();
    final selectedTheme = NewFormBuilderTheme.presetTheme(_themePreset);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Design Studio'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 1100;
            final studio = stacked
                ? [
                    _StudioPanel(
                      title: 'Form Design Controls',
                      child: _Controls(
                        themePreset: _themePreset,
                        layoutPreset: _layoutPreset,
                        animationPreset: _animationPreset,
                        densityPreset: _densityPreset,
                        onThemeChanged: (value) => setState(() => _themePreset = value),
                        onLayoutChanged: (value) => setState(() => _layoutPreset = value),
                        onAnimationChanged: (value) => setState(() => _animationPreset = value),
                        onDensityChanged: (value) => setState(() => _densityPreset = value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StudioPanel(
                      title: 'Live Preview',
                      child: _LivePreview(
                        theme: selectedTheme,
                        layoutPreset: _layoutPreset,
                        animationPreset: _animationPreset,
                        densityPreset: _densityPreset,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      flex: 2,
                      child: _StudioPanel(
                        title: 'Form Design Controls',
                        child: _Controls(
                          themePreset: _themePreset,
                          layoutPreset: _layoutPreset,
                          animationPreset: _animationPreset,
                          densityPreset: _densityPreset,
                          onThemeChanged: (value) => setState(() => _themePreset = value),
                          onLayoutChanged: (value) => setState(() => _layoutPreset = value),
                          onAnimationChanged: (value) => setState(() => _animationPreset = value),
                          onDensityChanged: (value) => setState(() => _densityPreset = value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _StudioPanel(
                        title: 'Live Preview',
                        child: _LivePreview(
                          theme: selectedTheme,
                          layoutPreset: _layoutPreset,
                          animationPreset: _animationPreset,
                          densityPreset: _densityPreset,
                        ),
                      ),
                    ),
                  ];

            return Padding(
              padding: const EdgeInsets.all(20),
              child: stacked
                  ? ListView(
                      children: studio,
                    )
                  : Row(children: studio),
            );
          },
        ),
      ),
    );
  }
}

class _StudioPanel extends StatelessWidget {
  const _StudioPanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.themePreset,
    required this.layoutPreset,
    required this.animationPreset,
    required this.densityPreset,
    required this.onThemeChanged,
    required this.onLayoutChanged,
    required this.onAnimationChanged,
    required this.onDensityChanged,
  });

  final FormBuilderThemePreset themePreset;
  final DesignLayoutPreset layoutPreset;
  final DesignAnimationPreset animationPreset;
  final DesignDensityPreset densityPreset;
  final ValueChanged<FormBuilderThemePreset> onThemeChanged;
  final ValueChanged<DesignLayoutPreset> onLayoutChanged;
  final ValueChanged<DesignAnimationPreset> onAnimationChanged;
  final ValueChanged<DesignDensityPreset> onDensityChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _ChoiceGroup<FormBuilderThemePreset>(
          title: 'Theme',
          selected: themePreset,
          options: const {
            FormBuilderThemePreset.enterprise: 'Enterprise',
            FormBuilderThemePreset.dark: 'Dark',
            FormBuilderThemePreset.creative: 'Creative',
            FormBuilderThemePreset.minimal: 'Minimal',
          },
          onChanged: onThemeChanged,
        ),
        const SizedBox(height: 16),
        _ChoiceGroup<DesignLayoutPreset>(
          title: 'Layout',
          selected: layoutPreset,
          options: const {
            DesignLayoutPreset.singlePage: 'Single page',
            DesignLayoutPreset.wizard: 'Wizard',
            DesignLayoutPreset.sidebarNav: 'Sidebar nav',
            DesignLayoutPreset.cardStack: 'Card stack',
          },
          onChanged: onLayoutChanged,
        ),
        const SizedBox(height: 16),
        _ChoiceGroup<DesignAnimationPreset>(
          title: 'Animation',
          selected: animationPreset,
          options: const {
            DesignAnimationPreset.none: 'None',
            DesignAnimationPreset.fade: 'Fade',
            DesignAnimationPreset.slide: 'Slide',
            DesignAnimationPreset.scale: 'Scale',
            DesignAnimationPreset.expandCollapse: 'Expand/collapse',
          },
          onChanged: onAnimationChanged,
        ),
        const SizedBox(height: 16),
        _ChoiceGroup<DesignDensityPreset>(
          title: 'Density',
          selected: densityPreset,
          options: const {
            DesignDensityPreset.compact: 'Compact',
            DesignDensityPreset.comfortable: 'Comfortable',
            DesignDensityPreset.spacious: 'Spacious',
          },
          onChanged: onDensityChanged,
        ),
        const SizedBox(height: 20),
        const _TokenPreview(),
      ],
    );
  }
}

class _ChoiceGroup<T> extends StatelessWidget {
  const _ChoiceGroup({
    required this.title,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final T selected;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in options.entries)
              ChoiceChip(
                label: Text(entry.value),
                selected: selected == entry.key,
                onSelected: (_) => onChanged(entry.key),
              ),
          ],
        ),
      ],
    );
  }
}

class _TokenPreview extends StatelessWidget {
  const _TokenPreview();

  @override
  Widget build(BuildContext context) {
    final theme = NewFormBuilderTheme.presetTheme(FormBuilderThemePreset.enterprise);
    return Card(
      color: theme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Selected tokens', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MiniToken(label: 'Primary', color: theme.primary),
                _MiniToken(label: 'Accent', color: theme.accent),
                _MiniToken(label: 'Border', color: theme.border),
                _MiniToken(label: 'Success', color: theme.success),
                _MiniToken(label: 'Error', color: theme.error),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniToken extends StatelessWidget {
  const _MiniToken({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: Text(label),
    );
  }
}

class _LivePreview extends StatelessWidget {
  const _LivePreview({
    required this.theme,
    required this.layoutPreset,
    required this.animationPreset,
    required this.densityPreset,
  });

  final NewFormBuilderTheme theme;
  final DesignLayoutPreset layoutPreset;
  final DesignAnimationPreset animationPreset;
  final DesignDensityPreset densityPreset;

  double get _spacing {
    switch (densityPreset) {
      case DesignDensityPreset.compact:
        return 8;
      case DesignDensityPreset.comfortable:
        return 14;
      case DesignDensityPreset.spacious:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _buildPreview(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _PreviewDot(color: theme.primary),
              const SizedBox(width: 8),
              _PreviewDot(color: theme.accent),
              const SizedBox(width: 8),
              _PreviewDot(color: theme.success),
              const Spacer(),
              Text(
                '${layoutPreset.name}  ·  ${animationPreset.name}  ·  ${densityPreset.name}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: theme.mutedText),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(child: preview),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    switch (layoutPreset) {
      case DesignLayoutPreset.singlePage:
        return _PreviewCardStack(theme: theme, spacing: _spacing, rows: 3);
      case DesignLayoutPreset.wizard:
        return _WizardPreview(theme: theme, spacing: _spacing);
      case DesignLayoutPreset.sidebarNav:
        return Row(
          children: [
            SizedBox(width: 170, child: _SidebarPreview(theme: theme)),
            SizedBox(width: _spacing),
            Expanded(child: _PreviewCardStack(theme: theme, spacing: _spacing, rows: 2)),
          ],
        );
      case DesignLayoutPreset.cardStack:
        return _PreviewCardStack(theme: theme, spacing: _spacing, rows: 4);
    }
  }
}

class _PreviewDot extends StatelessWidget {
  const _PreviewDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PreviewCardStack extends StatelessWidget {
  const _PreviewCardStack({required this.theme, required this.spacing, required this.rows});

  final NewFormBuilderTheme theme;
  final double spacing;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: rows,
      separatorBuilder: (context, _) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final widths = [1.0, 0.72, 0.88];
        return AnimatedBuilder(
          animation: AlwaysStoppedAnimation<double>(1),
          builder: (context, _) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 12, decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(99))),
                  SizedBox(height: spacing),
                  _Line(color: theme.border, widthFactor: widths[index % widths.length]),
                  SizedBox(height: spacing / 1.3),
                  _Line(color: theme.border, widthFactor: 0.84),
                  SizedBox(height: spacing / 1.3),
                  _Line(color: theme.border, widthFactor: 0.65),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SidebarPreview extends StatelessWidget {
  const _SidebarPreview({required this.theme});

  final NewFormBuilderTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Sections', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final label in ['Applicant', 'Identity', 'Documents', 'Review'])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: label == 'Identity' ? theme.primary.withValues(alpha: 0.12) : theme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(label),
              ),
            ),
        ],
      ),
    );
  }
}

class _WizardPreview extends StatelessWidget {
  const _WizardPreview({required this.theme, required this.spacing});

  final NewFormBuilderTheme theme;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final step in ['1', '2', '3', '4'])
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: step == '4' ? 0 : spacing),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: step == '2' ? theme.primary : theme.border.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing * 2),
        Expanded(child: _PreviewCardStack(theme: theme, spacing: spacing, rows: 2)),
        SizedBox(height: spacing),
        Row(
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Back')),
            const SizedBox(width: 12),
            FilledButton(onPressed: () {}, child: const Text('Next')),
          ],
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.color, required this.widthFactor});

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
