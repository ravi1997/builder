import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';

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

class NewFormBuilderPage extends StatefulWidget {
  const NewFormBuilderPage({super.key});

  @override
  State<NewFormBuilderPage> createState() => _NewFormBuilderPageState();
}

class _NewFormBuilderPageState extends State<NewFormBuilderPage> {
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

  // List of all 24 layouts (conversational chat layout removed)
  final List<LayoutOption> _layouts = const [
    // Single Page Layouts
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

    // Wizard / Step Based Layouts
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

    // Navigation Based Layouts
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

    // Progress Based Layouts
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

    // Card Based Layouts
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

    // Advanced Layouts
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

  @override
  Widget build(BuildContext context) {
    // Filter layouts
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
            const Divider(height: 1, color: AdiyogiColors.borderLight),

            // --- MAIN CONTENT SPLIT ---
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LEFT SIDEBAR (Width 320) ---
                  _buildLeftSidebar(context, filteredLayouts),
                  const VerticalDivider(width: 1, color: AdiyogiColors.borderLight),

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
          // Left Logo / Title
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
                    color: AdiyogiColors.pureWhite,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Form Layout Explorer',
                style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 18),
              ),
            ],
          ),

          // Center Search
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
                hintStyle: TextStyle(fontSize: 13, color: AdiyogiColors.greyMuted),
                prefixIcon: Icon(Icons.search, size: 16, color: AdiyogiColors.greyMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
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

  Widget _buildLeftSidebar(BuildContext context, List<LayoutOption> filteredLayouts) {
    return Container(
      width: 320,
      color: AdiyogiColors.pureWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Form Design Controls',
              style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16),
            ),
          ),
          const Divider(height: 1, color: AdiyogiColors.borderLight),

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
          const Divider(height: 1, color: AdiyogiColors.borderLight),

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
        ],
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
          color: AdiyogiColors.pureWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Preview',
                style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 16),
              ),
              Text(
                'Layout: ${_layouts.firstWhere((element) => element.id == _selectedLayoutId).name}',
                style: AdiyogiTextStyles.uiMicro(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AdiyogiColors.borderLight),

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
                  color: AdiyogiColors.surfaceWhite,
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
                    backgroundColor: AdiyogiColors.surfaceWhite,
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
