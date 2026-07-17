import 'package:flutter/material.dart';
import '../models/form_theme_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';
import '../pages/new_form_builder_page.dart';
import '../widgets/reusable_widgets.dart';

class StyleSelectorPanel extends StatelessWidget {
  final List<DesignCategoryOption> designCategories;
  final String activeDesignCategory;
  final FormThemeConfig themeConfig;
  final AnimationConfig animConfig;
  final ComponentStyleConfig componentConfig;
  final ValueChanged<String> onCategoryTapped;
  final ValueChanged<FormThemeConfig> onThemeConfigChanged;
  final ValueChanged<AnimationConfig> onAnimConfigChanged;
  final ValueChanged<ComponentStyleConfig> onComponentConfigChanged;
  final VoidCallback onBack;
  final VoidCallback onSyncTheme;

  const StyleSelectorPanel({
    super.key,
    required this.designCategories,
    required this.activeDesignCategory,
    required this.themeConfig,
    required this.animConfig,
    required this.componentConfig,
    required this.onCategoryTapped,
    required this.onThemeConfigChanged,
    required this.onAnimConfigChanged,
    required this.onComponentConfigChanged,
    required this.onBack,
    required this.onSyncTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      color: AdiyogiColors.shellWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, size: 16, color: AdiyogiColors.shellGreyBody),
                      SizedBox(width: 8),
                      Text('Back to Layouts', style: TextStyle(fontSize: 13, color: AdiyogiColors.shellGreyBody)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Form Design Controls',
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16, color: AdiyogiColors.shellCharcoal),
            ),
          ),
          const Divider(height: 1, color: AdiyogiColors.shellBorder),
          Expanded(
            child: ListView.builder(
              itemCount: designCategories.length,
              itemBuilder: (context, index) {
                final cat = designCategories[index];
                final selected = activeDesignCategory == cat.id;

                return Column(
                  children: [
                    Material(
                      color: selected ? AdiyogiColors.shellBackground : Colors.transparent,
                      child: ListTile(
                        leading: Icon(cat.icon, color: selected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyMuted),
                        title: Text(
                          cat.name,
                          style: AdiyogiTextStyles.labelMedium(context).copyWith(
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: AdiyogiColors.shellCharcoal,
                          ),
                        ),
                        subtitle: Text(
                          cat.description,
                          style: AdiyogiTextStyles.uiMicro(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => onCategoryTapped(cat.id),
                      ),
                    ),
                    if (selected)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AdiyogiColors.shellBackground,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _buildActiveCategoryControls(context, cat.id),
                        ),
                      ),
                    const Divider(height: 1, color: AdiyogiColors.shellBorder),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveCategoryControls(BuildContext context, String categoryId) {
    switch (categoryId) {
      case 'theme':
        return [
          _buildThemePresetSelector(context),
          const SizedBox(height: 12),
          const Text('Colors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AdiyogiColors.shellCharcoal)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorIndicator('Primary', themeConfig.primary, (color) {
                onThemeConfigChanged(themeConfig.copyWith(primary: color));
                onSyncTheme();
              }),
              _buildColorIndicator('Secondary', themeConfig.secondary, (color) {
                onThemeConfigChanged(themeConfig.copyWith(secondary: color));
                onSyncTheme();
              }),
              _buildColorIndicator('Accent', themeConfig.accent, (color) {
                onThemeConfigChanged(themeConfig.copyWith(accent: color));
                onSyncTheme();
              }),
              _buildColorIndicator('Background', themeConfig.background, (color) {
                onThemeConfigChanged(themeConfig.copyWith(background: color));
                onSyncTheme();
              }),
              _buildColorIndicator('Card', themeConfig.cardColor, (color) {
                onThemeConfigChanged(themeConfig.copyWith(cardColor: color));
                onSyncTheme();
              }),
              _buildColorIndicator('Text', themeConfig.textColor, (color) {
                onThemeConfigChanged(themeConfig.copyWith(textColor: color));
                onSyncTheme();
              }),
            ],
          ),
        ];
      case 'typography':
        return [
          _buildDropdownControl<FontStylePreset>(
            'Font Family',
            themeConfig.fontFamily,
            FontStylePreset.values,
            (val) {
              if (val != null) {
                onThemeConfigChanged(themeConfig.copyWith(fontFamily: val));
                onSyncTheme();
              }
            },
          ),
          const SizedBox(height: 12),
          _buildSliderControl('Title Size', themeConfig.titleSize, 16.0, 36.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(titleSize: val));
          }),
          _buildSliderControl('Section Size', themeConfig.sectionSize, 12.0, 24.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(sectionSize: val));
          }),
          _buildSliderControl('Question Size', themeConfig.questionSize, 10.0, 18.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(questionSize: val));
          }),
        ];
      case 'spacing':
        return [
          _buildSliderControl('Form Padding', themeConfig.formPadding, 8.0, 48.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(formPadding: val));
          }),
          _buildSliderControl('Section Spacing', themeConfig.sectionSpacing, 8.0, 48.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(sectionSpacing: val));
          }),
          _buildSliderControl('Question Spacing', themeConfig.questionSpacing, 4.0, 32.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(questionSpacing: val));
          }),
          _buildSliderControl('Input Padding', themeConfig.inputPadding, 4.0, 24.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(inputPadding: val));
          }),
        ];
      case 'shapes':
        return [
          _buildDropdownControl<ShapeStylePreset>(
            'Border Radius',
            themeConfig.borderRadius == 0.0
                ? ShapeStylePreset.square
                : themeConfig.borderRadius == 6.0
                    ? ShapeStylePreset.slightRounded
                    : themeConfig.borderRadius == 24.0
                        ? ShapeStylePreset.extraRounded
                        : ShapeStylePreset.rounded,
            ShapeStylePreset.values,
            (val) {
              if (val != null) {
                double radiusValue = 12.0;
                if (val == ShapeStylePreset.square) radiusValue = 0.0;
                if (val == ShapeStylePreset.slightRounded) radiusValue = 6.0;
                if (val == ShapeStylePreset.extraRounded) radiusValue = 24.0;
                if (val == ShapeStylePreset.pill) radiusValue = 30.0;
                onThemeConfigChanged(themeConfig.copyWith(borderRadius: radiusValue));
                onSyncTheme();
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<CardStylePreset>(
            'Card Style',
            componentConfig.cardStyle,
            CardStylePreset.values,
            (val) {
              if (val != null) {
                onComponentConfigChanged(componentConfig.copyWith(cardStyle: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<BorderStylePreset>(
            'Border Thickness',
            componentConfig.borderStyle,
            BorderStylePreset.values,
            (val) {
              if (val != null) {
                onComponentConfigChanged(componentConfig.copyWith(borderStyle: val));
              }
            },
          ),
        ];
      case 'animation':
        return [
          _buildDropdownControl<PageTransitionPreset>(
            'Page Transition Style',
            animConfig.transition,
            PageTransitionPreset.values,
            (val) {
              if (val != null) {
                onAnimConfigChanged(animConfig.copyWith(transition: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<AnimationCurvePreset>(
            'Animation Curve',
            animConfig.curve,
            AnimationCurvePreset.values,
            (val) {
              if (val != null) {
                onAnimConfigChanged(animConfig.copyWith(curve: val));
              }
            },
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildThemePresetSelector(BuildContext context) {
    final presets = const [
      ThemePresetOption(
        id: 'minimal',
        name: 'Minimal',
        icon: Icons.crop_din,
        primary: Color(0xFF1B1B21),
        background: Color(0xFFF7F7F8),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF121218),
      ),
      ThemePresetOption(
        id: 'dark',
        name: 'Dark Mode',
        icon: Icons.dark_mode_outlined,
        primary: Color(0xFFFFFFFF),
        background: Color(0xFF121218),
        cardColor: Color(0xFF1B1B21),
        textColor: Color(0xFFFFFFFF),
      ),
      ThemePresetOption(
        id: 'glassmorphism',
        name: 'Glassmorphism',
        icon: Icons.blur_on,
        primary: Color(0xFF3F51B5),
        background: Color(0xFFE0E6ED),
        cardColor: Color(0x99FFFFFF),
        textColor: Color(0xFF1C2D42),
      ),
      ThemePresetOption(
        id: 'material',
        name: 'Material',
        icon: Icons.layers_outlined,
        primary: Color(0xFF6200EE),
        background: Color(0xFFF5F5F5),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF212121),
      ),
      ThemePresetOption(
        id: 'survey',
        name: 'Survey Teal',
        icon: Icons.assignment_outlined,
        primary: Color(0xFF00796B),
        background: Color(0xFFE0F2F1),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF004D40),
      ),
      ThemePresetOption(
        id: 'neumorphism',
        name: 'Neumorphism',
        icon: Icons.tonality,
        primary: Color(0xFF5C6BC0),
        background: Color(0xFFE0E0E0),
        cardColor: Color(0xFFE0E0E0),
        textColor: Color(0xFF333333),
      ),
      ThemePresetOption(
        id: 'enterprise',
        name: 'Enterprise Blue',
        icon: Icons.business,
        primary: Color(0xFF0D47A1),
        background: Color(0xFFECEFF1),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF263238),
      ),
      ThemePresetOption(
        id: 'rounded',
        name: 'Modern Pink',
        icon: Icons.circle_outlined,
        primary: Color(0xFFE91E63),
        background: Color(0xFFFFF0F5),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF4A0033),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Theme Preset', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...presets.map((preset) {
          final isSelected = themeConfig.themePreset == preset.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: InkWell(
              onTap: () {
                onThemeConfigChanged(themeConfig.copyWith(
                  themePreset: preset.id,
                  primary: preset.primary,
                  background: preset.background,
                  cardColor: preset.cardColor,
                  textColor: preset.textColor,
                ));
                onSyncTheme();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? AdiyogiColors.shellBackground : AdiyogiColors.shellWhite,
                  border: Border.all(
                    color: isSelected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellBorder,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(preset.icon, size: 16, color: isSelected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        preset.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: AdiyogiColors.shellCharcoal,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildMiniSwatch(preset.primary),
                        const SizedBox(width: 4),
                        _buildMiniSwatch(preset.background),
                        const SizedBox(width: 4),
                        _buildMiniSwatch(preset.cardColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMiniSwatch(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 0.5),
      ),
    );
  }

  Widget _buildColorIndicator(String label, Color color, ValueChanged<Color> onChanged) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final colors = [const Color(0xFF1B1B21), const Color(0xFF3F51B5), const Color(0xFF4CAF50), const Color(0xFFE91E63), const Color(0xFFF7F7F8)];
            final currentIdx = colors.indexOf(color);
            final nextIdx = (currentIdx + 1) % colors.length;
            onChanged(colors[nextIdx]);
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AdiyogiColors.shellBorder),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDropdownControl<T>(String label, T current, List<T> values, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AdiyogiColors.shellBorder),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: current,
              isExpanded: true,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              onChanged: onChanged,
              items: values.map((val) {
                return DropdownMenuItem<T>(
                  value: val,
                  child: Text(val.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderControl(String label, double val, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(val.toStringAsFixed(1), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          activeColor: AdiyogiColors.shellCharcoal,
          inactiveColor: AdiyogiColors.shellBorder,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class ThemePresetOption {
  final String id;
  final String name;
  final IconData icon;
  final Color primary;
  final Color background;
  final Color cardColor;
  final Color textColor;

  const ThemePresetOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.primary,
    required this.background,
    required this.cardColor,
    required this.textColor,
  });
}
