import 'dart:math';
import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';
import '../models/form_theme_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';
import '../panels/layout_selector.dart';
import '../panels/style_selector.dart';

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
    FormThemeState.titleSize = _themeConfig.titleSize;
    FormThemeState.sectionSize = _themeConfig.sectionSize;
    FormThemeState.questionSize = _themeConfig.questionSize;
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
                      ? LayoutSelectorPanel(
                          layouts: _layouts,
                          selectedLayoutId: _selectedLayoutId,
                          selectedCategory: _selectedCategory,
                          searchQuery: _searchQuery,
                          onLayoutSelected: (id) => setState(() => _selectedLayoutId = id),
                          onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                          onSearchChanged: (val) => setState(() => _searchQuery = val),
                          onContinue: () => setState(() => _wizardStep = 2),
                        )
                      : StyleSelectorPanel(
                          designCategories: _designCategories,
                          activeDesignCategory: _activeDesignCategory,
                          themeConfig: _themeConfig,
                          animConfig: _animConfig,
                          componentConfig: _componentConfig,
                          onCategoryTapped: (id) => setState(() => _activeDesignCategory = id),
                          onThemeConfigChanged: (cfg) => setState(() => _themeConfig = cfg),
                          onAnimConfigChanged: (cfg) => setState(() => _animConfig = cfg),
                          onComponentConfigChanged: (cfg) => setState(() => _componentConfig = cfg),
                          onBack: () => setState(() => _wizardStep = 1),
                          onSyncTheme: _syncThemeState,
                        ),
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
              Row(
                children: [
                  const Text(
                    'Live Preview',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  ToggleButtons(
                    isSelected: [FormThemeState.skeletonMode, !FormThemeState.skeletonMode],
                    onPressed: (index) {
                      setState(() {
                        FormThemeState.skeletonMode = index == 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    constraints: const BoxConstraints(minHeight: 24, minWidth: 70),
                    children: const [
                      Text('Skeleton', style: TextStyle(fontSize: 10)),
                      Text('Real Text', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
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
