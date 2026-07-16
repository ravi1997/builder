import 'dart:math';
import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';
import '../models/builder_config.dart';

class LayoutOption {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String category;

  const LayoutOption({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
  });
}

class DesignCategoryOption {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  const DesignCategoryOption({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}


class NewFormBuilderPage extends StatefulWidget {
  const NewFormBuilderPage({super.key});

  @override
  State<NewFormBuilderPage> createState() => _NewFormBuilderPageState();
}

class _NewFormBuilderPageState extends State<NewFormBuilderPage> {
  // Wizard state: 1 = Layout Selection, 2 = Theme & Customization
  int _wizardStep = 1;

  // Mock form schema
  final FormSchema _schema = FormSchema.mock;

  // Form values state to simulate actual filling
  final Map<String, dynamic> _formValues = {};

  // Device preview modes
  String _previewMode = 'Desktop'; // Desktop, Tablet, Mobile

  // Selection states
  String _selectedLayoutId = 'classic';
  String _searchQuery = '';
  String _selectedCategory = 'All';
  // Active category in style step
  String _activeDesignCategory = 'theme';

  final List<DesignCategoryOption> _designCategories = const [
    DesignCategoryOption(
      id: 'theme',
      name: 'Theme & Palette',
      description: 'Customize primary, background, and text colors.',
      icon: Icons.palette,
    ),
    DesignCategoryOption(
      id: 'typography',
      name: 'Typography & Fonts',
      description: 'Adjust font families and heading weights.',
      icon: Icons.text_fields,
    ),
    DesignCategoryOption(
      id: 'spacing',
      name: 'Density & Spacing',
      description: 'Tune paddings, margins, and question spacing.',
      icon: Icons.space_bar,
    ),
    DesignCategoryOption(
      id: 'shapes',
      name: 'Shapes & Borders',
      description: 'Control card rounding, input borders, and card styles.',
      icon: Icons.rounded_corner,
    ),
    DesignCategoryOption(
      id: 'animation',
      name: 'Transition & Speed',
      description: 'Set page transitions and speed modifiers.',
      icon: Icons.animation,
    ),
  ];

  // Config models for Step 2
  FormThemeConfig _themeConfig = const FormThemeConfig();
  SpacingConfig _spacingConfig = const SpacingConfig();
  ShapeStyleConfig _shapeConfig = const ShapeStyleConfig();
  AnimationConfig _animConfig = const AnimationConfig();

  // List of all 24 layouts
  final List<LayoutOption> _layouts = const [
    LayoutOption(
      id: 'classic',
      name: 'Classic Long Form',
      description: 'All sections visible vertically separated by clean cards.',
      icon: Icons.list_alt,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'collapsible',
      name: 'Collapsible Sections',
      description: 'Accordion style container that expands or collapses.',
      icon: Icons.view_headline,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'accordion_single',
      name: 'Accordion Single Open',
      description: 'Only one section is expanded at a time.',
      icon: Icons.unfold_more,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'two_col',
      name: 'Two Column Form',
      description: 'Fields arranged in responsive 2-column structure.',
      icon: Icons.grid_view_sharp,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'three_col',
      name: 'Three Column Grid Form',
      description: 'Dense enterprise style grid layout for power users.',
      icon: Icons.grid_on,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'wizard_section',
      name: 'Section Per Page Wizard',
      description: 'Each section is presented on a separate step.',
      icon: Icons.pages_outlined,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_question',
      name: 'Question Per Page Wizard',
      description: 'One single question shown at a time with progress tracker.',
      icon: Icons.looks_one,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_hybrid',
      name: 'Hybrid Wizard',
      description: 'Multiple questions grouped together per wizard step.',
      icon: Icons.dashboard_customize_outlined,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_mobile',
      name: 'Full Screen Mobile Wizard',
      description: 'Immersive full screen mobile onboarding experience.',
      icon: Icons.phone_android,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_swipe',
      name: 'Swipe Card Wizard',
      description: 'Card based swipe transition between pages.',
      icon: Icons.swipe,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'nav_left',
      name: 'Left Sidebar Navigation',
      description: 'Jump to sections using a sticky left sidebar menu.',
      icon: Icons.input_sharp,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_right',
      name: 'Right Sidebar Navigation',
      description: 'Jump to sections using a sticky right sidebar menu.',
      icon: Icons.output_sharp,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_top',
      name: 'Top Step Navigation',
      description: 'Quick top steps navigation representing sections.',
      icon: Icons.tab_unselected,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_tabs',
      name: 'Tabs Layout',
      description: 'Classic horizontal tab controller for sections.',
      icon: Icons.tab,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_breadcrumb',
      name: 'Breadcrumb Navigation Layout',
      description: 'Chronological path navigation hierarchy.',
      icon: Icons.arrow_right_alt,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'prog_horizontal',
      name: 'Horizontal Progress Stepper',
      description: 'Visual horizontal dots representing progress.',
      icon: Icons.commit,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_vertical',
      name: 'Vertical Progress Stepper',
      description: 'Vertical layout showing progress status checklist.',
      icon: Icons.more_vert,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_percent',
      name: 'Percentage Completion Layout',
      description: 'Clear percentage status indicator update.',
      icon: Icons.percent,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_checklist',
      name: 'Checklist Completion Layout',
      description: 'Checklist checklist tracker.',
      icon: Icons.fact_check_outlined,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'card_question',
      name: 'Question Card Layout',
      description: 'Each question resides in its own micro container.',
      icon: Icons.crop_square_outlined,
      category: 'Card',
    ),
    LayoutOption(
      id: 'card_section',
      name: 'Section Card Layout',
      description: 'Renders sections inside deep card shapes.',
      icon: Icons.picture_in_picture_alt,
      category: 'Card',
    ),
    LayoutOption(
      id: 'kanban_sections',
      name: 'Kanban Style Form Sections',
      description: 'Interactive boards displaying section completeness.',
      icon: Icons.view_column_outlined,
      category: 'Card',
    ),
    LayoutOption(
      id: 'adv_conditional',
      name: 'Conditional Dynamic Form',
      description: 'Show or hide elements depending on answers.',
      icon: Icons.alt_route,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_review',
      name: 'Review Before Submit Layout',
      description: 'Overview display of answers before final submission.',
      icon: Icons.preview,
      category: 'Advanced',
    ),
  ];

  // Sync builder configuration parameters with the static global FormThemeState
  void _syncThemeState() {
    FormThemeState.primary = _themeConfig.primary;
    FormThemeState.background = _themeConfig.background;
    FormThemeState.cardColor = _themeConfig.cardColor;
    FormThemeState.textColor = _themeConfig.textColor;

    if (_themeConfig.fontFamily == FontStylePreset.roboto) {
      FormThemeState.fontFamily = 'Roboto';
    } else if (_themeConfig.fontFamily == FontStylePreset.poppins) {
      FormThemeState.fontFamily = 'Poppins';
    } else if (_themeConfig.fontFamily == FontStylePreset.serif) {
      FormThemeState.fontFamily = 'Lora';
    } else {
      FormThemeState.fontFamily = 'Instrument Sans';
    }

    if (_shapeConfig.borderRadius == ShapeStylePreset.square) {
      FormThemeState.borderRadius = 0.0;
    } else if (_shapeConfig.borderRadius == ShapeStylePreset.slightRounded) {
      FormThemeState.borderRadius = 6.0;
    } else if (_shapeConfig.borderRadius == ShapeStylePreset.extraRounded) {
      FormThemeState.borderRadius = 24.0;
    } else {
      FormThemeState.borderRadius = 12.0;
    }
  }

  void _resetConfig() {
    setState(() {
      _themeConfig = const FormThemeConfig();
      _spacingConfig = const SpacingConfig();
      _shapeConfig = const ShapeStyleConfig();
      _animConfig = const AnimationConfig();
      _syncThemeState();
    });
  }

  void _randomizeConfig() {
    final random = Random();
    setState(() {
      final randomColor = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
      _themeConfig = FormThemeConfig(
        primary: randomColor,
        secondary: randomColor.withValues(alpha: 0.7),
        accent: randomColor.withValues(alpha: 0.5),
        textColor: random.nextBool() ? const Color(0xFF121218) : const Color(0xFFFFFFFF),
        background: random.nextBool() ? const Color(0xFFF7F7F8) : const Color(0xFF1B1B21),
        fontFamily: FontStylePreset.values[random.nextInt(FontStylePreset.values.length)],
      );

      _shapeConfig = ShapeStyleConfig(
        borderRadius: ShapeStylePreset.values[random.nextInt(ShapeStylePreset.values.length)],
      );

      _syncThemeState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter layouts for Step 1
    final filteredLayouts = _layouts.where((l) {
      final matchesSearch = l.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || l.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AdiyogiColors.surfaceWhite,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP TOOLBAR ---
            _buildTopToolbar(context),
            Divider(height: 1, color: AdiyogiColors.borderLight),

            // --- MAIN CONTENT SPLIT ---
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LEFT SIDEBAR (Width 340) ---
                  _wizardStep == 1
                      ? _buildLeftSidebarStep1(context, filteredLayouts)
                      : _buildLeftSidebarStep2(context),
                   VerticalDivider(width: 1, color: AdiyogiColors.borderLight),

                  // --- RIGHT PREVIEW CANVAS ---
                  Expanded(
                    child: _buildRightPreview(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopToolbar(BuildContext context) {
    return Container(
      color: AdiyogiColors.pureWhite,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AdiyogiColors.charcoal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'A.D.I.Y.O.G.I',
                  style: TextStyle(
                    fontFamily: 'Instrument Sans',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _wizardStep == 1 ? 'Form Layout Explorer' : 'Form Layout & Theme Builder',
                style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 18),
              ),
            ],
          ),

          // Toolbar center search if Step 1
          if (_wizardStep == 1)
            Container(
              width: 320,
              height: 38,
              decoration: BoxDecoration(
                color: AdiyogiColors.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AdiyogiColors.borderLight),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search layout catalog...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            )
          else
            // Actions for Step 2
            Row(
              children: [
                TextButton.icon(
                  onPressed: _resetConfig,
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: const Text('Reset', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: AdiyogiColors.greyBody),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _randomizeConfig,
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: const Text('Randomize', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdiyogiColors.charcoal,
                    foregroundColor: AdiyogiColors.pureWhite,
                  ),
                ),
              ],
            ),

          // Right Controls: Devices
          Row(
            children: [
              _buildDeviceButton(Icons.desktop_windows, 'Desktop'),
              const SizedBox(width: 4),
              _buildDeviceButton(Icons.tablet_mac, 'Tablet'),
              const SizedBox(width: 4),
              _buildDeviceButton(Icons.phone_iphone, 'Mobile'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceButton(IconData icon, String mode) {
    final active = _previewMode == mode;
    return OutlinedButton.icon(
      onPressed: () => setState(() => _previewMode = mode),
      icon: Icon(icon, size: 16, color: active ? AdiyogiColors.pureWhite : AdiyogiColors.charcoal),
      label: Text(mode, style: TextStyle(fontSize: 12, color: active ? AdiyogiColors.pureWhite : AdiyogiColors.charcoal)),
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AdiyogiColors.charcoal : Colors.transparent,
        side: BorderSide(color: active ? AdiyogiColors.charcoal : AdiyogiColors.borderLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildLeftSidebarStep1(BuildContext context, List<LayoutOption> filteredLayouts) {
    return Container(
      width: 340,
      color: AdiyogiColors.pureWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Form Design Controls',
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16),
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.borderLight),

          // Horizontal category picker
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: ['All', 'Single Page', 'Wizard / Step', 'Navigation', 'Progress', 'Card', 'Advanced'].map((cat) {
                final active = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: active ? AdiyogiColors.surfaceSubtle : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          color: active ? AdiyogiColors.inkBlack : AdiyogiColors.greyBody,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.borderLight),

          // Layout List
          Expanded(
            child: ListView.builder(
              itemCount: filteredLayouts.length,
              itemBuilder: (context, index) {
                final l = filteredLayouts[index];
                final selected = _selectedLayoutId == l.id;
                return Material(
                  color: selected ? AdiyogiColors.surfaceWhite : Colors.transparent,
                  child: ListTile(
                    leading: Icon(l.icon, color: selected ? AdiyogiColors.charcoal : AdiyogiColors.greyMuted),
                    title: Text(
                      l.name,
                      style: AdiyogiTextStyles.labelMedium(context).copyWith(
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      l.description,
                      style: AdiyogiTextStyles.uiMicro(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => setState(() => _selectedLayoutId = l.id),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.borderLight),

          // CONTINUE BUTTON
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _wizardStep = 2;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AdiyogiColors.charcoal,
                foregroundColor: AdiyogiColors.pureWhite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Continue to Style Config', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebarStep2(BuildContext context) {
    return Container(
      width: 340,
      color: AdiyogiColors.pureWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _wizardStep = 1),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16, color: AdiyogiColors.greyBody),
                      const SizedBox(width: 8),
                      Text('Back to Layouts', style: TextStyle(fontSize: 13, color: AdiyogiColors.greyBody)),
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
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16),
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.borderLight),

          // Scrollable Categories list containing their respective controls inline when active
          Expanded(
            child: ListView.builder(
              itemCount: _designCategories.length,
              itemBuilder: (context, index) {
                final cat = _designCategories[index];
                final selected = _activeDesignCategory == cat.id;

                return Column(
                  children: [
                    Material(
                      color: selected ? AdiyogiColors.surfaceWhite : Colors.transparent,
                      child: ListTile(
                        leading: Icon(cat.icon, color: selected ? AdiyogiColors.charcoal : AdiyogiColors.greyMuted),
                        title: Text(
                          cat.name,
                          style: AdiyogiTextStyles.labelMedium(context).copyWith(
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          cat.description,
                          style: AdiyogiTextStyles.uiMicro(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => setState(() => _activeDesignCategory = cat.id),
                      ),
                    ),
                    if (selected)
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AdiyogiColors.surfaceWhite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _buildActiveCategoryControls(cat.id),
                        ),
                      ),
                    Divider(height: 1, color: AdiyogiColors.borderLight),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveCategoryControls(String categoryId) {
    switch (categoryId) {
      case 'theme':
        return [
          _buildThemePresetSelector(),
          const SizedBox(height: 12),
          _buildColorPickerRow(),
        ];
      case 'typography':
        return [
          _buildDropdownControl<FontStylePreset>(
            'Font Family',
            _themeConfig.fontFamily,
            FontStylePreset.values,
            (val) {
              if (val != null) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(fontFamily: val);
                  _syncThemeState();
                });
              }
            },
          ),
        ];
      case 'spacing':
        return [
          _buildSliderControl('Form Spacing', _spacingConfig.formPadding, 8.0, 48.0, (val) {
            setState(() => _spacingConfig = _spacingConfig.copyWith(formPadding: val));
          }),
          _buildSliderControl('Question Spacing', _spacingConfig.questionSpacing, 4.0, 32.0, (val) {
            setState(() => _spacingConfig = _spacingConfig.copyWith(questionSpacing: val));
          }),
        ];
      case 'shapes':
        return [
          _buildDropdownControl<ShapeStylePreset>(
            'Border Radius',
            _shapeConfig.borderRadius,
            ShapeStylePreset.values,
            (val) {
              if (val != null) {
                setState(() {
                  _shapeConfig = _shapeConfig.copyWith(borderRadius: val);
                  _syncThemeState();
                });
              }
            },
          ),
        ];
      case 'animation':
        return [
          _buildDropdownControl<PageTransitionPreset>(
            'Page Transition Style',
            _animConfig.transition,
            PageTransitionPreset.values,
            (val) => setState(() => _animConfig = _animConfig.copyWith(transition: val)),
          ),
        ];
      default:
        return [];
    }
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
            border: Border.all(color: AdiyogiColors.borderLight),
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

  Widget _buildSliderControl(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text('${value.toInt()}px', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AdiyogiColors.charcoal,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildThemePresetSelector() {
    final presets = ['minimal', 'dark', 'material', 'survey'];
    return _buildDropdownControl<String>(
      'Theme Preset',
      _themeConfig.themePreset,
      presets,
      (val) {
        if (val == 'dark') {
          setState(() {
            _themeConfig = _themeConfig.copyWith(
              themePreset: val,
              primary: Colors.white,
              background: const Color(0xFF121218),
              textColor: Colors.white,
              cardColor: const Color(0xFF1B1B21),
            );
            _syncThemeState();
          });
        } else {
          setState(() {
            _themeConfig = _themeConfig.copyWith(
              themePreset: val,
              primary: const Color(0xFF1B1B21),
              background: const Color(0xFFF7F7F8),
              textColor: const Color(0xFF121218),
              cardColor: Colors.white,
            );
            _syncThemeState();
          });
        }
      },
    );
  }

  Widget _buildColorPickerRow() {
    return Row(
      children: [
        _buildColorIndicator('Primary', _themeConfig.primary, (color) {
          setState(() {
            _themeConfig = _themeConfig.copyWith(primary: color);
            _syncThemeState();
          });
        }),
        const SizedBox(width: 8),
        _buildColorIndicator('Background', _themeConfig.background, (color) {
          setState(() {
            _themeConfig = _themeConfig.copyWith(background: color);
            _syncThemeState();
          });
        }),
      ],
    );
  }

  Widget _buildColorIndicator(String label, Color color, ValueChanged<Color> onChanged) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Cycle colors for demo/simulation
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
              border: Border.all(color: AdiyogiColors.borderLight),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildRightPreview(BuildContext context) {
    // Determine canvas constraints based on previewMode
    double? maxWidth;
    double? height;
    if (_previewMode == 'Mobile') {
      maxWidth = 375;
      height = 740;
    } else if (_previewMode == 'Tablet') {
      maxWidth = 768;
      height = 960;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Header bar
        Container(
          color: AdiyogiColors.pureWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Preview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Layout: ${_layouts.firstWhere((element) => element.id == _selectedLayoutId).name}',
                style: AdiyogiTextStyles.uiMicro(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AdiyogiColors.borderLight),

        // Preview Canvas Box
        Expanded(
          child: Container(
            color: AdiyogiColors.surfaceSubtle,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: maxWidth,
                height: height,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: FormThemeState.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Scaffold(
                    backgroundColor: FormThemeState.background,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _renderActiveLayout(),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderActiveLayout() {
    switch (_selectedLayoutId) {
      case 'classic':
        return ClassicLongForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'collapsible':
        return CollapsibleSectionsForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'accordion_single':
        return AccordionSingleOpenForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'two_col':
        return TwoColumnForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'three_col':
        return ThreeColumnGridForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'wizard_section':
        return SectionPerPageWizard(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'wizard_question':
        return QuestionPerPageWizard(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'wizard_hybrid':
        return HybridWizard(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'wizard_mobile':
        return FullScreenMobileWizard(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'wizard_swipe':
        return SwipeCardWizard(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_left':
        return LeftSidebarNavigationForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_right':
        return RightSidebarNavigationForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_top':
        return TopStepNavigationForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_tabs':
        return TabsLayoutForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_breadcrumb':
        return BreadcrumbNavigationLayout(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_horizontal':
        return HorizontalProgressStepperForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_vertical':
        return VerticalProgressStepperForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_percent':
        return PercentageCompletionForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_checklist':
        return ChecklistCompletionForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'card_question':
        return QuestionCardForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'card_section':
        return SectionCardForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'kanban_sections':
        return KanbanStyleFormSections(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_conditional':
        return ConditionalDynamicForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_review':
        return ReviewBeforeSubmitLayout(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      default:
        return ClassicLongForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
    }
  }

  void _onFormValueChanged(String fieldId, dynamic value) {
    setState(() {
      _formValues[fieldId] = value;
    });
  }
}
