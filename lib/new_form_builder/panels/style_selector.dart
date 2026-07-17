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
          _buildDropdownControl<BackgroundPreset>(
            'Background Preset',
            themeConfig.backgroundPreset,
            BackgroundPreset.values,
            (val) {
              if (val != null) {
                onThemeConfigChanged(themeConfig.copyWith(backgroundPreset: val));
                onSyncTheme();
              }
            },
          ),
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
          _buildDropdownControl<SpacingPreset>(
            'Spacing Preset',
            themeConfig.spacingPreset,
            SpacingPreset.values,
            (val) {
              if (val != null) {
                onThemeConfigChanged(_applySpacingPreset(themeConfig, val));
                onSyncTheme();
              }
            },
          ),
          const SizedBox(height: 12),
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
          _buildSliderControl('Button Spacing', themeConfig.buttonSpacing, 4.0, 32.0, (val) {
            onThemeConfigChanged(themeConfig.copyWith(buttonSpacing: val));
          }),
          const SizedBox(height: 12),
          _buildDropdownControl<FormWidthPreset>(
            'Form Width',
            themeConfig.formWidthPreset,
            FormWidthPreset.values,
            (val) {
              if (val != null) {
                onThemeConfigChanged(themeConfig.copyWith(formWidthPreset: val));
                onSyncTheme();
              }
            },
          ),
        ];
      case 'shapes':
        return [
          _buildDropdownControl<InputStylePreset>(
            'Input Style',
            componentConfig.inputStyle,
            InputStylePreset.values,
            (val) {
              if (val != null) {
                onComponentConfigChanged(componentConfig.copyWith(inputStyle: val));
              }
            },
          ),
          const SizedBox(height: 12),
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
          _buildDropdownControl<ButtonStylePreset>(
            'Button Style',
            componentConfig.buttonStyle,
            ButtonStylePreset.values,
            (val) {
              if (val != null) {
                onComponentConfigChanged(componentConfig.copyWith(buttonStyle: val));
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
          const SizedBox(height: 12),
          _buildDropdownControl<ShadowPreset>(
            'Shadow Level',
            componentConfig.shadowLevel,
            ShadowPreset.values,
            (val) {
              if (val != null) {
                onComponentConfigChanged(componentConfig.copyWith(shadowLevel: val));
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
          _buildDropdownControl<SectionAnimationPreset>(
            'Section Animation',
            animConfig.sectionAnim,
            SectionAnimationPreset.values,
            (val) {
              if (val != null) {
                onAnimConfigChanged(animConfig.copyWith(sectionAnim: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<InputAnimationPreset>(
            'Input Animation',
            animConfig.inputAnim,
            InputAnimationPreset.values,
            (val) {
              if (val != null) {
                onAnimConfigChanged(animConfig.copyWith(inputAnim: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildSliderControl('Animation Duration', animConfig.duration.inMilliseconds.toDouble(), 100.0, 700.0, (val) {
            onAnimConfigChanged(animConfig.copyWith(duration: Duration(milliseconds: val.toInt())));
          }),
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

  FormThemeConfig _applySpacingPreset(FormThemeConfig theme, SpacingPreset preset) {
    switch (preset) {
      case SpacingPreset.compact:
        return theme.copyWith(
          spacingPreset: preset,
          formPadding: 16.0,
          sectionSpacing: 16.0,
          questionSpacing: 10.0,
          inputPadding: 8.0,
          buttonSpacing: 8.0,
        );
      case SpacingPreset.comfortable:
        return theme.copyWith(
          spacingPreset: preset,
          formPadding: 24.0,
          sectionSpacing: 24.0,
          questionSpacing: 16.0,
          inputPadding: 12.0,
          buttonSpacing: 12.0,
        );
      case SpacingPreset.spacious:
        return theme.copyWith(
          spacingPreset: preset,
          formPadding: 32.0,
          sectionSpacing: 32.0,
          questionSpacing: 20.0,
          inputPadding: 16.0,
          buttonSpacing: 16.0,
        );
    }
  }

  Widget _buildThemePresetSelector(BuildContext context) {
    final presets = const [
      ThemePresetOption(
        id: 'minimal',
        name: 'Clean White',
        icon: Icons.crop_din,
        primary: Color(0xFF1B1B21),
        background: Color(0xFFF7F7F8),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF121218),
        secondary: Color(0xFF44454C),
        accent: Color(0xFF3B82F6),
        inputColor: Color(0xFFE5E7EB),
        errorColor: Color(0xFFDC2626),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'soft_gray',
        name: 'Soft Gray',
        icon: Icons.filter_b_and_w,
        primary: Color(0xFF3B82F6),
        background: Color(0xFFF8FAFC),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF1E293B),
        secondary: Color(0xFF475569),
        accent: Color(0xFF0EA5E9),
        inputColor: Color(0xFFCBD5E1),
        errorColor: Color(0xFFDC2626),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'warm_neutral',
        name: 'Warm Neutral',
        icon: Icons.wb_sunny_outlined,
        primary: Color(0xFFB45309),
        background: Color(0xFFFAF9F6),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF292524),
        secondary: Color(0xFF57534E),
        accent: Color(0xFFF59E0B),
        inputColor: Color(0xFFD6D3D1),
        errorColor: Color(0xFFB91C1C),
        successColor: Color(0xFF15803D),
      ),
      ThemePresetOption(
        id: 'professional_blue',
        name: 'Blue Professional',
        icon: Icons.business_center_outlined,
        primary: Color(0xFF2563EB),
        background: Color(0xFFF8FAFC),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF0F172A),
        secondary: Color(0xFF334155),
        accent: Color(0xFF38BDF8),
        inputColor: Color(0xFFCBD5E1),
        errorColor: Color(0xFFDC2626),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'creative_purple',
        name: 'Purple Creative',
        icon: Icons.auto_awesome,
        primary: Color(0xFF7C3AED),
        background: Color(0xFFFAF5FF),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF312E81),
        secondary: Color(0xFF6B7280),
        accent: Color(0xFFF472B6),
        inputColor: Color(0xFFE9D5FF),
        errorColor: Color(0xFFDB2777),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'trust_green',
        name: 'Green Trust',
        icon: Icons.verified_outlined,
        primary: Color(0xFF16A34A),
        background: Color(0xFFF0FDF4),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF14532D),
        secondary: Color(0xFF166534),
        accent: Color(0xFF22C55E),
        inputColor: Color(0xFFBBF7D0),
        errorColor: Color(0xFFDC2626),
        successColor: Color(0xFF15803D),
      ),
      ThemePresetOption(
        id: 'friendly_orange',
        name: 'Orange Friendly',
        icon: Icons.volunteer_activism_outlined,
        primary: Color(0xFFF97316),
        background: Color(0xFFFFFBEB),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF7C2D12),
        secondary: Color(0xFF9A3412),
        accent: Color(0xFFFACC15),
        inputColor: Color(0xFFFDE68A),
        errorColor: Color(0xFFDC2626),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'dark_professional',
        name: 'Dark Professional',
        icon: Icons.dark_mode_outlined,
        primary: Color(0xFF3B82F6),
        background: Color(0xFF0F172A),
        cardColor: Color(0xFF1E293B),
        textColor: Color(0xFFFFFFFF),
        secondary: Color(0xFFCBD5E1),
        accent: Color(0xFF38BDF8),
        inputColor: Color(0xFF334155),
        errorColor: Color(0xFFF87171),
        successColor: Color(0xFF4ADE80),
      ),
      ThemePresetOption(
        id: 'dark_neon',
        name: 'Dark Neon',
        icon: Icons.blur_on,
        primary: Color(0xFF22D3EE),
        background: Color(0xFF000000),
        cardColor: Color(0xFF111111),
        textColor: Color(0xFFF8FAFC),
        secondary: Color(0xFFA78BFA),
        accent: Color(0xFFEC4899),
        inputColor: Color(0xFF27272A),
        errorColor: Color(0xFFF87171),
        successColor: Color(0xFF34D399),
      ),
      ThemePresetOption(
        id: 'dark_luxury',
        name: 'Dark Luxury',
        icon: Icons.workspace_premium_outlined,
        primary: Color(0xFFD4AF37),
        background: Color(0xFF111111),
        cardColor: Color(0xFF1A1A1A),
        textColor: Color(0xFFF5F1E8),
        secondary: Color(0xFFB45309),
        accent: Color(0xFFFBBF24),
        inputColor: Color(0xFF2A2A2A),
        errorColor: Color(0xFFEF4444),
        successColor: Color(0xFF4ADE80),
      ),
      ThemePresetOption(
        id: 'pastel_soft',
        name: 'Soft Pastel',
        icon: Icons.palette_outlined,
        primary: Color(0xFFFB7185),
        background: Color(0xFFFFF7ED),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF7C2D12),
        secondary: Color(0xFFA7F3D0),
        accent: Color(0xFFFDE68A),
        inputColor: Color(0xFFFBCFE8),
        errorColor: Color(0xFFF43F5E),
        successColor: Color(0xFF22C55E),
      ),
      ThemePresetOption(
        id: 'baby_blue',
        name: 'Baby Blue',
        icon: Icons.cloud_outlined,
        primary: Color(0xFF60A5FA),
        background: Color(0xFFEFF6FF),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF1E3A8A),
        secondary: Color(0xFF93C5FD),
        accent: Color(0xFFA5F3FC),
        inputColor: Color(0xFFBFDBFE),
        errorColor: Color(0xFFEF4444),
        successColor: Color(0xFF22C55E),
      ),
      ThemePresetOption(
        id: 'lavender',
        name: 'Lavender',
        icon: Icons.local_florist_outlined,
        primary: Color(0xFF8B5CF6),
        background: Color(0xFFFAF5FF),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF4C1D95),
        secondary: Color(0xFFC084FC),
        accent: Color(0xFFE879F9),
        inputColor: Color(0xFFE9D5FF),
        errorColor: Color(0xFFDB2777),
        successColor: Color(0xFF22C55E),
      ),
      ThemePresetOption(
        id: 'material',
        name: 'Material Blue',
        icon: Icons.layers_outlined,
        primary: Color(0xFF1976D2),
        background: Color(0xFFF5F5F5),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF212121),
        secondary: Color(0xFF424242),
        accent: Color(0xFF9C27B0),
        inputColor: Color(0xFFE0E0E0),
        errorColor: Color(0xFFD32F2F),
        successColor: Color(0xFF388E3C),
      ),
      ThemePresetOption(
        id: 'survey',
        name: 'Survey Teal',
        icon: Icons.assignment_outlined,
        primary: Color(0xFF00796B),
        background: Color(0xFFE0F2F1),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF004D40),
        secondary: Color(0xFF00695C),
        accent: Color(0xFF26A69A),
        inputColor: Color(0xFFB2DFDB),
        errorColor: Color(0xFFE53935),
        successColor: Color(0xFF2E7D32),
      ),
      ThemePresetOption(
        id: 'monochrome',
        name: 'Monochrome',
        icon: Icons.contrast_outlined,
        primary: Color(0xFF111111),
        background: Color(0xFFF8FAFC),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF111111),
        secondary: Color(0xFF475569),
        accent: Color(0xFF64748B),
        inputColor: Color(0xFFE2E8F0),
        errorColor: Color(0xFF991B1B),
        successColor: Color(0xFF166534),
      ),
      ThemePresetOption(
        id: 'glassmorphism',
        name: 'Glass',
        icon: Icons.blur_on,
        primary: Color(0xFF2563EB),
        background: Color(0xFFE0E6ED),
        cardColor: Color(0x99FFFFFF),
        textColor: Color(0xFF1C2D42),
        secondary: Color(0xFF475569),
        accent: Color(0xFF8B5CF6),
        inputColor: Color(0x80FFFFFF),
        errorColor: Color(0xFFEF4444),
        successColor: Color(0xFF10B981),
      ),
      ThemePresetOption(
        id: 'neumorphism',
        name: 'Neumorphism',
        icon: Icons.tonality,
        primary: Color(0xFF5C6BC0),
        background: Color(0xFFE0E0E0),
        cardColor: Color(0xFFE0E0E0),
        textColor: Color(0xFF333333),
        secondary: Color(0xFF6B7280),
        accent: Color(0xFF818CF8),
        inputColor: Color(0xFFD1D5DB),
        errorColor: Color(0xFFEF4444),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'enterprise',
        name: 'Enterprise Blue',
        icon: Icons.business,
        primary: Color(0xFF0D47A1),
        background: Color(0xFFECEFF1),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF263238),
        secondary: Color(0xFF37474F),
        accent: Color(0xFF0288D1),
        inputColor: Color(0xFFCFD8DC),
        errorColor: Color(0xFFB71C1C),
        successColor: Color(0xFF1B5E20),
      ),
      ThemePresetOption(
        id: 'coral',
        name: 'Coral',
        icon: Icons.circle_outlined,
        primary: Color(0xFFF97316),
        background: Color(0xFFFFF7ED),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF7C2D12),
        secondary: Color(0xFF9A3412),
        accent: Color(0xFFF59E0B),
        inputColor: Color(0xFFFCD34D),
        errorColor: Color(0xFFEF4444),
        successColor: Color(0xFF16A34A),
      ),
      ThemePresetOption(
        id: 'navy_finance',
        name: 'Navy Finance',
        icon: Icons.account_balance_outlined,
        primary: Color(0xFF0F172A),
        background: Color(0xFFF8FAFC),
        cardColor: Color(0xFFFFFFFF),
        textColor: Color(0xFF0F172A),
        secondary: Color(0xFF334155),
        accent: Color(0xFFD4AF37),
        inputColor: Color(0xFFCBD5E1),
        errorColor: Color(0xFFB91C1C),
        successColor: Color(0xFF15803D),
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
                onThemeConfigChanged(_applyThemePreset(themeConfig, preset));
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

  FormThemeConfig _applyThemePreset(FormThemeConfig current, ThemePresetOption preset) {
    return current.copyWith(
      themePreset: preset.id,
      primary: preset.primary,
      secondary: preset.secondary ?? current.secondary,
      accent: preset.accent ?? current.accent,
      background: preset.background,
      cardColor: preset.cardColor,
      inputColor: preset.inputColor ?? current.inputColor,
      textColor: preset.textColor,
      errorColor: preset.errorColor ?? current.errorColor,
      successColor: preset.successColor ?? current.successColor,
      backgroundPreset: preset.backgroundPreset ?? current.backgroundPreset,
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
  final Color? secondary;
  final Color? accent;
  final Color background;
  final Color cardColor;
  final Color? inputColor;
  final Color textColor;
  final Color? errorColor;
  final Color? successColor;
  final BackgroundPreset? backgroundPreset;

  const ThemePresetOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.primary,
    this.secondary,
    this.accent,
    required this.background,
    required this.cardColor,
    this.inputColor,
    required this.textColor,
    this.errorColor,
    this.successColor,
    this.backgroundPreset,
  });
}
