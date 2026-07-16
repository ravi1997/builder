import 'dart:math';
import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';
import '../models/form_theme_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';

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
  AnimationConfig _animConfig = const AnimationConfig();
  ComponentStyleConfig _componentConfig = const ComponentStyleConfig();

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
      id: 'accordion_multiple',
      name: 'Accordion Multiple Open',
      description: 'Multiple sections can expand or collapse simultaneously.',
      icon: Icons.unfold_more_double,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'nav_tree',
      name: 'Tree Navigation Form',
      description: 'Hierarchical nested folder trees representing sections.',
      icon: Icons.account_tree_outlined,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'prog_bar',
      name: 'Linear Progress Bar',
      description: 'Top persistent completion bar indicator.',
      icon: Icons.linear_scale,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_step',
      name: 'Numerical Step Indicator',
      description: 'Numerical bubbles showing completed steps.',
      icon: Icons.looks_one_outlined,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'adv_conversational',
      name: 'Conversational Form',
      description: 'Focused overlays prompting sequentially.',
      icon: Icons.text_snippet_outlined,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_chat',
      name: 'Chat Style Form',
      description: 'Interactive AI dialogue capturing inputs.',
      icon: Icons.chat_bubble_outline,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_drawer',
      name: 'Drawer Styled Form',
      description: 'Form panel slides in from the right edge.',
      icon: Icons.view_sidebar_outlined,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_modal',
      name: 'Modal Dialog Form',
      description: 'Form displays centered inside a popup window.',
      icon: Icons.picture_in_picture_outlined,
      category: 'Advanced',
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
    } else if (_themeConfig.fontFamily == FontStylePreset.lora) {
      FormThemeState.fontFamily = 'Lora';
    } else {
      FormThemeState.fontFamily = 'Instrument Sans';
    }

    FormThemeState.borderRadius = _themeConfig.borderRadius;
  }

  void _resetConfig() {
    setState(() {
      _themeConfig = const FormThemeConfig();
      _animConfig = const AnimationConfig();
      _componentConfig = const ComponentStyleConfig();
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
        borderRadius: [0.0, 6.0, 12.0, 24.0][random.nextInt(4)],
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
      backgroundColor: AdiyogiColors.shellBackground,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP TOOLBAR ---
            _buildTopToolbar(context),
            Divider(height: 1, color: AdiyogiColors.shellBorder),

            // --- MAIN CONTENT SPLIT ---
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LEFT SIDEBAR (Width 340) ---
                  _wizardStep == 1
                      ? _buildLeftSidebarStep1(context, filteredLayouts)
                      : _buildLeftSidebarStep2(context),
                   VerticalDivider(width: 1, color: AdiyogiColors.shellBorder),

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
      color: AdiyogiColors.shellWhite,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AdiyogiColors.shellCharcoal,
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
                color: AdiyogiColors.shellBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AdiyogiColors.shellBorder),
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
                  style: TextButton.styleFrom(foregroundColor: AdiyogiColors.shellGreyBody),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _randomizeConfig,
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: const Text('Randomize', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdiyogiColors.shellCharcoal,
                    foregroundColor: AdiyogiColors.shellWhite,
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
      icon: Icon(icon, size: 16, color: active ? AdiyogiColors.shellWhite : AdiyogiColors.shellCharcoal),
      label: Text(mode, style: TextStyle(fontSize: 12, color: active ? AdiyogiColors.shellWhite : AdiyogiColors.shellCharcoal)),
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AdiyogiColors.shellCharcoal : Colors.transparent,
        side: BorderSide(color: active ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildLeftSidebarStep1(BuildContext context, List<LayoutOption> filteredLayouts) {
    return Container(
      width: 340,
      color: AdiyogiColors.shellWhite,
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
          Divider(height: 1, color: AdiyogiColors.shellBorder),

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
                          color: active ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.shellBorder),

          // Layout List
          Expanded(
            child: ListView.builder(
              itemCount: filteredLayouts.length,
              itemBuilder: (context, index) {
                final l = filteredLayouts[index];
                final selected = _selectedLayoutId == l.id;
                return Material(
                  color: selected ? AdiyogiColors.shellBackground : Colors.transparent,
                  child: ListTile(
                    leading: Icon(l.icon, color: selected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyMuted),
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
          Divider(height: 1, color: AdiyogiColors.shellBorder),

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
                backgroundColor: AdiyogiColors.shellCharcoal,
                foregroundColor: AdiyogiColors.shellWhite,
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
      color: AdiyogiColors.shellWhite,
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
                      Icon(Icons.arrow_back, size: 16, color: AdiyogiColors.shellGreyBody),
                      const SizedBox(width: 8),
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
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16),
            ),
          ),
          Divider(height: 1, color: AdiyogiColors.shellBorder),

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
                      color: selected ? AdiyogiColors.shellBackground : Colors.transparent,
                      child: ListTile(
                        leading: Icon(cat.icon, color: selected ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyMuted),
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
                        color: AdiyogiColors.shellBackground,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _buildActiveCategoryControls(cat.id),
                        ),
                      ),
                    Divider(height: 1, color: AdiyogiColors.shellBorder),
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
          const Text('Colors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorIndicator('Primary', _themeConfig.primary, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(primary: color);
                  _syncThemeState();
                });
              }),
              _buildColorIndicator('Secondary', _themeConfig.secondary, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(secondary: color);
                  _syncThemeState();
                });
              }),
              _buildColorIndicator('Accent', _themeConfig.accent, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(accent: color);
                  _syncThemeState();
                });
              }),
              _buildColorIndicator('Background', _themeConfig.background, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(background: color);
                  _syncThemeState();
                });
              }),
              _buildColorIndicator('Card', _themeConfig.cardColor, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(cardColor: color);
                  _syncThemeState();
                });
              }),
              _buildColorIndicator('Text', _themeConfig.textColor, (color) {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(textColor: color);
                  _syncThemeState();
                });
              }),
            ],
          ),
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
          const SizedBox(height: 12),
          _buildSliderControl('Title Size', _themeConfig.titleSize, 16.0, 36.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(titleSize: val));
          }),
          _buildSliderControl('Section Size', _themeConfig.sectionSize, 12.0, 24.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(sectionSize: val));
          }),
          _buildSliderControl('Question Size', _themeConfig.questionSize, 10.0, 18.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(questionSize: val));
          }),
        ];
      case 'spacing':
        return [
          _buildSliderControl('Form Padding', _themeConfig.formPadding, 8.0, 48.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(formPadding: val));
          }),
          _buildSliderControl('Section Spacing', _themeConfig.sectionSpacing, 8.0, 48.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(sectionSpacing: val));
          }),
          _buildSliderControl('Question Spacing', _themeConfig.questionSpacing, 4.0, 32.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(questionSpacing: val));
          }),
          _buildSliderControl('Input Padding', _themeConfig.inputPadding, 4.0, 24.0, (val) {
            setState(() => _themeConfig = _themeConfig.copyWith(inputPadding: val));
          }),
        ];
      case 'shapes':
        return [
          _buildDropdownControl<ShapeStylePreset>(
            'Border Radius',
            _themeConfig.borderRadius == 0.0
                ? ShapeStylePreset.square
                : _themeConfig.borderRadius == 6.0
                    ? ShapeStylePreset.slightRounded
                    : _themeConfig.borderRadius == 24.0
                        ? ShapeStylePreset.extraRounded
                        : ShapeStylePreset.rounded,
            ShapeStylePreset.values,
            (val) {
              if (val != null) {
                setState(() {
                  double radiusValue = 12.0;
                  if (val == ShapeStylePreset.square) radiusValue = 0.0;
                  if (val == ShapeStylePreset.slightRounded) radiusValue = 6.0;
                  if (val == ShapeStylePreset.extraRounded) radiusValue = 24.0;
                  if (val == ShapeStylePreset.pill) radiusValue = 30.0;

                  _themeConfig = _themeConfig.copyWith(
                    borderRadius: radiusValue,
                  );
                  _syncThemeState();
                });
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<CardStylePreset>(
            'Card Style',
            _componentConfig.cardStyle,
            CardStylePreset.values,
            (val) {
              if (val != null) {
                setState(() => _componentConfig = _componentConfig.copyWith(cardStyle: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<BorderStylePreset>(
            'Border Thickness',
            _componentConfig.borderStyle,
            BorderStylePreset.values,
            (val) {
              if (val != null) {
                setState(() => _componentConfig = _componentConfig.copyWith(borderStyle: val));
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
            (val) {
              if (val != null) {
                setState(() => _animConfig = _animConfig.copyWith(transition: val));
              }
            },
          ),
          const SizedBox(height: 12),
          _buildDropdownControl<AnimationCurvePreset>(
            'Animation Curve',
            _animConfig.curve,
            AnimationCurvePreset.values,
            (val) {
              if (val != null) {
                setState(() => _animConfig = _animConfig.copyWith(curve: val));
              }
            },
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
          activeColor: AdiyogiColors.shellCharcoal,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildThemePresetSelector() {
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
          final isSelected = _themeConfig.themePreset == preset.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: InkWell(
              onTap: () {
                setState(() {
                  _themeConfig = _themeConfig.copyWith(
                    themePreset: preset.id,
                    primary: preset.primary,
                    background: preset.background,
                    cardColor: preset.cardColor,
                    textColor: preset.textColor,
                  );
                  _syncThemeState();
                });
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
                    // Swatches
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
              border: Border.all(color: AdiyogiColors.shellBorder),
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
          color: AdiyogiColors.shellWhite,
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
        Divider(height: 1, color: AdiyogiColors.shellBorder),

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
      case 'accordion_multiple':
        return AccordionMultipleOpenForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'nav_tree':
        return TreeNavigationForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_bar':
        return ProgressBarForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'prog_step':
        return StepIndicatorForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_conversational':
        return ConversationalForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_chat':
        return ChatStyleForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_drawer':
        return DrawerForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
      case 'adv_modal':
        return ModalForm(schema: _schema, formValues: _formValues, onValueChanged: _onFormValueChanged);
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
