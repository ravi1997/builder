import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';
import '../models/form_theme_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';
import '../panels/layout_selector.dart';
import '../panels/style_selector.dart';
import '../providers/form_builder_provider.dart';

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

class NewFormBuilderPage extends ConsumerStatefulWidget {
  const NewFormBuilderPage({super.key});

  @override
  ConsumerState<NewFormBuilderPage> createState() => _NewFormBuilderPageState();
}

class _NewFormBuilderPageState extends ConsumerState<NewFormBuilderPage> {
  // Mock form schema
  final FormSchema _schema = FormSchema.mock;

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
      icon: Icons.unfold_more,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'accordion_single',
      name: 'Accordion Single Open',
      description: 'Allows only one section card to be expanded at a time.',
      icon: Icons.view_headline,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'accordion_multiple',
      name: 'Accordion Multiple Open',
      description: 'Multiple section cards can be expanded at the same time.',
      icon: Icons.view_stream,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'card_section',
      name: 'Section Cards',
      description: 'Wraps sections in clear elevated cards with borders.',
      icon: Icons.crop_portrait,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'two_col',
      name: 'Two Column Form',
      description: 'Renders questions side-by-side in double columns.',
      icon: Icons.view_column,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'three_col',
      name: 'Three Column Grid',
      description: 'Maximizes desktop density with a triple column grid.',
      icon: Icons.grid_on,
      category: 'Single Page',
    ),
    LayoutOption(
      id: 'wizard_section',
      name: 'Section Per Page',
      description: 'Wizard layout showing exactly one section card per step.',
      icon: Icons.arrow_forward_ios,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_question',
      name: 'Question Per Page',
      description: 'Increases completion rate by showing one question card.',
      icon: Icons.crop_square_sharp,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_hybrid',
      name: 'Hybrid Page View',
      description: 'Balances sections and questions in page splits.',
      icon: Icons.wb_iridescent,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_mobile',
      name: 'FullScreen Mobile Step',
      description: 'Optimized touch layout stretching elements to full bounds.',
      icon: Icons.stay_current_portrait,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'wizard_swipe',
      name: 'Swipe Card Wizard',
      description: 'Gestures-driven card layout allowing swipe navigation.',
      icon: Icons.view_carousel,
      category: 'Wizard / Step',
    ),
    LayoutOption(
      id: 'nav_left',
      name: 'Left Sidebar Navigation',
      description: 'Places interactive tab indices on the left sidebar.',
      icon: Icons.align_horizontal_left,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_right',
      name: 'Right Sidebar Navigation',
      description: 'Places structural layouts index navigation on the right.',
      icon: Icons.align_horizontal_right,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_top',
      name: 'Top Step Nav Tabs',
      description: 'Classic stepper design header buttons for tab views.',
      icon: Icons.view_day_outlined,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_tabs',
      name: 'Horizontal Tabs Layout',
      description: 'Wraps sections in cleanly styled sliding tab headers.',
      icon: Icons.tab,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_breadcrumb',
      name: 'Breadcrumb Navigation',
      description: 'Shows hierarchical step indicators inside layouts.',
      icon: Icons.linear_scale,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'nav_tree',
      name: 'Tree Navigation Form',
      description: 'Renders collapsible folder-like tree items on the side.',
      icon: Icons.account_tree_outlined,
      category: 'Navigation',
    ),
    LayoutOption(
      id: 'prog_horizontal',
      name: 'Horizontal Stepper',
      description: 'Presents progress status indices in horizontal loops.',
      icon: Icons.linear_scale_sharp,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_vertical',
      name: 'Vertical Stepper Form',
      description: 'Steps rendered vertically alongside content cards.',
      icon: Icons.more_vert,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_percent',
      name: 'Percentage Indicator',
      description: 'Visual circular dial indicator tracking filled elements.',
      icon: Icons.donut_large,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_checklist',
      name: 'Checklist Completion',
      description: 'Shows status checkpoints validating user details.',
      icon: Icons.check_box,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_bar',
      name: 'Linear Progress Form',
      description: 'Draws a flat horizontal progress indicator header.',
      icon: Icons.trending_flat,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'prog_step',
      name: 'Step Count Indicators',
      description: 'Displays a numeric index counter inside form header.',
      icon: Icons.pin_end,
      category: 'Progress',
    ),
    LayoutOption(
      id: 'card_question',
      name: 'Question Cards',
      description: 'Draws an individual layout frame card for each question.',
      icon: Icons.view_headline_rounded,
      category: 'Card',
    ),
    LayoutOption(
      id: 'kanban_sections',
      name: 'Kanban Board Sections',
      description: 'Interactive board columns separating section questions.',
      icon: Icons.view_week,
      category: 'Card',
    ),
    LayoutOption(
      id: 'adv_conversational',
      name: 'Conversational Form',
      description: 'Renders exactly one active question focusing context.',
      icon: Icons.chat_bubble_outline_outlined,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_chat',
      name: 'Chat Style Layout',
      description: 'Renders questions side-by-side in dialogue bubble streams.',
      icon: Icons.forum_outlined,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_drawer',
      name: 'Sliding Drawer Form',
      description: 'Collapsible sliding panel wrapper hosting layouts.',
      icon: Icons.read_more,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_modal',
      name: 'Pop-up Modal Form',
      description: 'Dialog lightbox overlay wrapping section inputs.',
      icon: Icons.picture_in_picture_outlined,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_conditional',
      name: 'Conditional Fields',
      description: 'Layout dependencies showing/hiding form sections.',
      icon: Icons.rule,
      category: 'Advanced',
    ),
    LayoutOption(
      id: 'adv_review',
      name: 'Review & Submit Form',
      description: 'Overview display of answers before final submission.',
      icon: Icons.preview,
      category: 'Advanced',
    ),
  ];

  void _resetConfig() {
    ref.read(formBuilderProvider.notifier).execute(const UpdateThemeCommand(FormThemeConfig()));
    ref.read(formBuilderProvider.notifier).execute(const UpdateComponentStyleCommand(ComponentStyleConfig()));
    ref.read(formBuilderProvider.notifier).execute(const UpdateAnimationCommand(AnimationConfig()));
  }

  void _randomizeConfig() {
    final random = Random();
    final randomColor = Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
    final randomTheme = FormThemeConfig(
      primary: randomColor,
      textColor: random.nextBool() ? const Color(0xFF121218) : const Color(0xFFFFFFFF),
      background: random.nextBool() ? const Color(0xFFF7F7F8) : const Color(0xFF1B1B21),
      fontFamily: FontStylePreset.values[random.nextInt(FontStylePreset.values.length)],
      borderRadius: [0.0, 6.0, 12.0, 24.0][random.nextInt(4)],
    );
    ref.read(formBuilderProvider.notifier).execute(UpdateThemeCommand(randomTheme));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formBuilderProvider);
    final notifier = ref.read(formBuilderProvider.notifier);

    return FormThemeScope(
      themeConfig: state.themeConfig,
      componentConfig: state.componentConfig,
      animConfig: state.animConfig,
      skeletonMode: state.skeletonMode,
      child: Scaffold(
        backgroundColor: AdiyogiColors.shellBackground,
        body: SafeArea(
          child: Column(
            children: [
              // --- TOP TOOLBAR ---
              _buildTopToolbar(context, state, notifier),
              Divider(height: 1, color: AdiyogiColors.shellBorder),

              // --- MAIN CONTENT SPLIT ---
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- LEFT SIDEBAR ---
                    state.wizardStep == 1
                        ? LayoutSelectorPanel(
                            layouts: _layouts,
                            selectedLayoutId: state.selectedLayoutId,
                            selectedCategory: state.selectedCategory,
                            searchQuery: state.searchQuery,
                            onLayoutSelected: notifier.updateSelectedLayout,
                            onCategorySelected: notifier.updateSelectedCategory,
                            onSearchChanged: notifier.updateSearchQuery,
                            onContinue: () => notifier.updateWizardStep(2),
                          )
                        : StyleSelectorPanel(
                            designCategories: _designCategories,
                            activeDesignCategory: state.activeDesignCategory,
                            themeConfig: state.themeConfig,
                            animConfig: state.animConfig,
                            componentConfig: state.componentConfig,
                            onCategoryTapped: notifier.updateActiveDesignCategory,
                            onThemeConfigChanged: (cfg) => notifier.execute(UpdateThemeCommand(cfg)),
                            onAnimConfigChanged: (cfg) => notifier.execute(UpdateAnimationCommand(cfg)),
                            onComponentConfigChanged: (cfg) => notifier.execute(UpdateComponentStyleCommand(cfg)),
                            onBack: () => notifier.updateWizardStep(1),
                            onSyncTheme: () {},
                          ),
                    VerticalDivider(width: 1, color: AdiyogiColors.shellBorder),

                    // --- RIGHT PREVIEW CANVAS ---
                    Expanded(
                      child: _buildRightPreview(context, state, notifier),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopToolbar(BuildContext context, FormBuilderState state, FormBuilderNotifier notifier) {
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
                state.wizardStep == 1 ? 'Form Layout Explorer' : 'Form Layout & Theme Builder',
                style: AdiyogiTextStyles.sectionHeading(context).copyWith(fontSize: 18),
              ),
            ],
          ),

          // Toolbar center Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: notifier.canUndo ? notifier.undo : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                tooltip: 'Redo',
                onPressed: notifier.canRedo ? notifier.redo : null,
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _resetConfig,
                icon: const Icon(Icons.refresh, size: 16, color: AdiyogiColors.shellCharcoal),
                label: const Text('Reset', style: TextStyle(color: AdiyogiColors.shellCharcoal, fontSize: 12)),
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

          // Preview Canvas controllers
          Row(
            children: [
              _buildDeviceButton(Icons.desktop_windows, 'Desktop', state, notifier),
              const SizedBox(width: 8),
              _buildDeviceButton(Icons.tablet_mac, 'Tablet', state, notifier),
              const SizedBox(width: 8),
              _buildDeviceButton(Icons.phone_iphone, 'Mobile', state, notifier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceButton(IconData icon, String mode, FormBuilderState state, FormBuilderNotifier notifier) {
    final active = state.previewMode == mode;
    return OutlinedButton.icon(
      onPressed: () => notifier.updatePreviewMode(mode),
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

  Widget _buildRightPreview(BuildContext context, FormBuilderState state, FormBuilderNotifier notifier) {
    double? maxWidth;
    double? height;
    if (state.previewMode == 'Mobile') {
      maxWidth = 375;
      height = 740;
    } else if (state.previewMode == 'Tablet') {
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
                    isSelected: [state.skeletonMode, !state.skeletonMode],
                    onPressed: (index) {
                      notifier.updateSkeletonMode(index == 0);
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
                'Layout: ${_layouts.firstWhere((element) => element.id == state.selectedLayoutId).name}',
                style: AdiyogiTextStyles.uiMicro(context),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AdiyogiColors.shellBorder),

        // Preview Canvas Box
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: Container(decoration: buildBackgroundDecoration(state.themeConfig))),
              Positioned.fill(child: Container(decoration: buildBackgroundPattern(state.themeConfig))),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  width: state.previewMode == 'Desktop'
                      ? formMaxWidthForPreset(state.themeConfig.formWidthPreset, maxWidth ?? 1200)
                      : maxWidth,
                  height: height,
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: state.themeConfig.background,
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
                      backgroundColor: state.themeConfig.background,
                      body: SingleChildScrollView(
                        padding: EdgeInsets.all(state.themeConfig.formPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedSwitcher(
                              duration: state.animConfig.duration,
                              switchInCurve: state.animConfig.curveWidget,
                              switchOutCurve: state.animConfig.curveWidget.flipped,
                              transitionBuilder: (child, animation) =>
                                  _buildTransition(child, animation, state.animConfig.transition),
                              child: KeyedSubtree(
                                key: ValueKey('${state.selectedLayoutId}_${state.previewMode}_${state.skeletonMode}'),
                                child: _renderActiveLayout(state, notifier),
                              ),
                            ),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderActiveLayout(FormBuilderState state, FormBuilderNotifier notifier) {
    final values = state.formValues;
    final callback = notifier.updateFormValue;
    final layoutId = state.selectedLayoutId;

    switch (layoutId) {
      case 'classic':
        return ClassicLongForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'collapsible':
        return CollapsibleSectionsForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'accordion_single':
        return AccordionSingleOpenForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'two_col':
        return TwoColumnForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'three_col':
        return ThreeColumnGridForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'wizard_section':
        return SectionPerPageWizard(schema: _schema, formValues: values, onValueChanged: callback);
      case 'wizard_question':
        return QuestionPerPageWizard(schema: _schema, formValues: values, onValueChanged: callback);
      case 'wizard_hybrid':
        return HybridWizard(schema: _schema, formValues: values, onValueChanged: callback);
      case 'wizard_mobile':
        return FullScreenMobileWizard(schema: _schema, formValues: values, onValueChanged: callback);
      case 'wizard_swipe':
        return SwipeCardWizard(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_left':
        return LeftSidebarNavigationForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_right':
        return RightSidebarNavigationForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_top':
        return TopStepNavigationForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_tabs':
        return TabsLayoutForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_breadcrumb':
        return BreadcrumbNavigationLayout(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_horizontal':
        return HorizontalProgressStepperForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_vertical':
        return VerticalProgressStepperForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_percent':
        return PercentageCompletionForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_checklist':
        return ChecklistCompletionForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'card_question':
        return QuestionCardForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'card_section':
        return SectionCardForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'kanban_sections':
        return KanbanStyleFormSections(schema: _schema, formValues: values, onValueChanged: callback);
      case 'accordion_multiple':
        return AccordionMultipleOpenForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'nav_tree':
        return TreeNavigationForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_bar':
        return ProgressBarForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'prog_step':
        return StepIndicatorForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_conversational':
      case 'conversational':
        return ConversationalForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_chat':
      case 'chatStyle':
        return ChatStyleForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_drawer':
      case 'drawerStyle':
        return DrawerForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_modal':
      case 'modalStyle':
        return ModalForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_conditional':
        return ConditionalDynamicForm(schema: _schema, formValues: values, onValueChanged: callback);
      case 'adv_review':
      case 'reviewSubmit':
        return ReviewBeforeSubmitLayout(schema: _schema, formValues: values, onValueChanged: callback);
      default:
        return ClassicLongForm(schema: _schema, formValues: values, onValueChanged: callback);
    }
  }

  Widget _buildTransition(Widget child, Animation<double> animation, PageTransitionPreset transition) {
    switch (transition) {
      case PageTransitionPreset.none:
        return child;
      case PageTransitionPreset.fade:
        return FadeTransition(opacity: animation, child: child);
      case PageTransitionPreset.slide:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(animation),
          child: child,
        );
      case PageTransitionPreset.scale:
        return ScaleTransition(scale: animation, child: child);
      case PageTransitionPreset.push:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.14, 0.02), end: Offset.zero).animate(animation),
          child: child,
        );
      case PageTransitionPreset.flip:
        return RotationTransition(
          turns: Tween<double>(begin: 0.01, end: 0).animate(animation),
          child: child,
        );
    }
  }
}
