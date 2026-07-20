// ignore_for_file: unused_field
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';
import '../layouts/form_layouts.dart';
import '../models/form_layout_config.dart';
import '../models/form_theme_config.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';
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

  String _layoutSummary(FormLayoutConfig config) {
    final presentation = switch (config.presentationMode) {
      PresentationMode.page => 'Page',
      PresentationMode.modal => 'Modal',
      PresentationMode.drawer => 'Drawer',
      PresentationMode.embedded => 'Embedded',
    };
    final navigation = switch (config.navigationStyle) {
      NavigationStyle.scroll => 'Scroll',
      NavigationStyle.nextPrevious => 'Steps',
      NavigationStyle.topTabs => 'Tabs',
      NavigationStyle.leftSidebar => 'Sidebar',
      NavigationStyle.rightSidebar => 'Sidebar',
      NavigationStyle.accordion => 'Accordion',
      NavigationStyle.chat => 'Chat',
      NavigationStyle.breadcrumb => 'Breadcrumb',
      NavigationStyle.stepIndicator => 'Steps',
      NavigationStyle.progressBar => 'Progress',
      NavigationStyle.percentage => 'Progress',
      NavigationStyle.checklist => 'Checklist',
      NavigationStyle.none => 'Scroll',
    };
    final arrangement = switch (config.arrangementMode) {
      ArrangementMode.stack => 'Stack',
      ArrangementMode.grid => 'Grid',
      ArrangementMode.columns => 'Columns',
      ArrangementMode.cards => 'Cards',
      ArrangementMode.canvas => 'Canvas',
    };
    final logic = switch (config.logicMode) {
      LogicMode.linear => 'Linear',
      LogicMode.conditional => 'Conditional',
      LogicMode.branching => 'Branching',
      LogicMode.dynamic => 'Dynamic',
    };
    return '$presentation + $navigation + $arrangement + $logic';
  }

  // ignore: unused_element
  String _layoutPresetIdForConfig(FormLayoutConfig config) {
    if (config.navigationStyle == NavigationStyle.chat) return 'adv_chat';
    if (config.presentationMode == PresentationMode.drawer) return 'adv_drawer';
    if (config.presentationMode == PresentationMode.modal) return 'adv_modal';
    if (config.navigationStyle == NavigationStyle.leftSidebar)
      return 'nav_left';
    if (config.navigationStyle == NavigationStyle.rightSidebar)
      return 'nav_right';
    if (config.navigationStyle == NavigationStyle.topTabs) return 'nav_tabs';
    if (config.navigationStyle == NavigationStyle.accordion)
      return 'accordion_multiple';
    if (config.navigationStyle == NavigationStyle.breadcrumb)
      return 'nav_breadcrumb';
    if (config.navigationStyle == NavigationStyle.stepIndicator)
      return 'prog_step';
    if (config.navigationStyle == NavigationStyle.progressBar)
      return 'prog_bar';
    if (config.navigationStyle == NavigationStyle.percentage)
      return 'prog_percent';
    if (config.navigationStyle == NavigationStyle.checklist)
      return 'prog_checklist';
    if (config.arrangementMode == ArrangementMode.cards) return 'card_section';
    if (config.arrangementMode == ArrangementMode.grid) return 'three_col';
    if (config.arrangementMode == ArrangementMode.columns) return 'two_col';
    if (config.navigationStyle == NavigationStyle.nextPrevious)
      return 'wizard_section';
    return 'classic';
  }

  void _resetConfig() {
    ref
        .read(formBuilderProvider.notifier)
        .execute(const UpdateThemeCommand(FormThemeConfig()));
    ref
        .read(formBuilderProvider.notifier)
        .execute(const UpdateComponentStyleCommand(ComponentStyleConfig()));
    ref
        .read(formBuilderProvider.notifier)
        .execute(const UpdateAnimationCommand(AnimationConfig()));
  }

  void _randomizeConfig() {
    final random = Random();
    final randomColor = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    final randomTheme = FormThemeConfig(
      primary: randomColor,
      textColor: random.nextBool()
          ? const Color(0xFF121218)
          : const Color(0xFFFFFFFF),
      background: random.nextBool()
          ? const Color(0xFFF7F7F8)
          : const Color(0xFF1B1B21),
      fontFamily:
          FontStylePreset.values[random.nextInt(FontStylePreset.values.length)],
      borderRadius: [0.0, 6.0, 12.0, 24.0][random.nextInt(4)],
    );
    ref
        .read(formBuilderProvider.notifier)
        .execute(UpdateThemeCommand(randomTheme));
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
                        ? _LayoutConfigurationPanel(
                            layoutConfig: state.layoutConfig,
                            selectedLayoutId: state.selectedLayoutId,
                            onLayoutConfigChanged: (config, layoutId) =>
                                notifier.updateLayoutConfig(
                                  config,
                                  selectedLayoutId: layoutId,
                                ),
                            onBack: () => notifier.updateWizardStep(1),
                            onContinue: () => notifier.updateWizardStep(2),
                          )
                        : StyleSelectorPanel(
                            designCategories: _designCategories,
                            activeDesignCategory: state.activeDesignCategory,
                            themeConfig: state.themeConfig,
                            animConfig: state.animConfig,
                            componentConfig: state.componentConfig,
                            onCategoryTapped:
                                notifier.updateActiveDesignCategory,
                            onThemeConfigChanged: (cfg) =>
                                notifier.execute(UpdateThemeCommand(cfg)),
                            onAnimConfigChanged: (cfg) =>
                                notifier.execute(UpdateAnimationCommand(cfg)),
                            onComponentConfigChanged: (cfg) => notifier.execute(
                              UpdateComponentStyleCommand(cfg),
                            ),
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

  Widget _buildTopToolbar(
    BuildContext context,
    FormBuilderState state,
    FormBuilderNotifier notifier,
  ) {
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
                  color: AdiyogiColors.shellGreyBody,
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
                state.wizardStep == 1
                    ? 'Form Layout Explorer'
                    : 'Form Layout & Theme Builder',
                style: AdiyogiTextStyles.sectionHeading(
                  context,
                ).copyWith(fontSize: 18, color: AdiyogiColors.shellCharcoal),
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
                icon: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: AdiyogiColors.shellCharcoal,
                ),
                label: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AdiyogiColors.shellCharcoal,
                    fontSize: 12,
                  ),
                ),
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
              _buildDeviceButton(
                Icons.desktop_windows,
                'Desktop',
                state,
                notifier,
              ),
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

  Widget _buildDeviceButton(
    IconData icon,
    String mode,
    FormBuilderState state,
    FormBuilderNotifier notifier,
  ) {
    final active = state.previewMode == mode;
    return OutlinedButton.icon(
      onPressed: () => notifier.updatePreviewMode(mode),
      icon: Icon(
        icon,
        size: 16,
        color: active ? AdiyogiColors.shellWhite : AdiyogiColors.shellCharcoal,
      ),
      label: Text(
        mode,
        style: TextStyle(
          fontSize: 12,
          color: active
              ? AdiyogiColors.shellWhite
              : AdiyogiColors.shellCharcoal,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: active
            ? AdiyogiColors.shellCharcoal
            : Colors.transparent,
        side: BorderSide(
          color: active
              ? AdiyogiColors.shellCharcoal
              : AdiyogiColors.shellBorder,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildRightPreview(
    BuildContext context,
    FormBuilderState state,
    FormBuilderNotifier notifier,
  ) {
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AdiyogiColors.shellCharcoal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ToggleButtons(
                    isSelected: [state.skeletonMode, !state.skeletonMode],
                    onPressed: (index) {
                      notifier.updateSkeletonMode(index == 0);
                    },
                    borderRadius: BorderRadius.circular(6),
                    constraints: const BoxConstraints(
                      minHeight: 24,
                      minWidth: 70,
                    ),
                    children: const [
                      Text(
                        'Skeleton',
                        style: TextStyle(
                          fontSize: 10,
                          color: AdiyogiColors.shellCharcoal,
                        ),
                      ),
                      Text(
                        'Real Text',
                        style: TextStyle(
                          fontSize: 10,
                          color: AdiyogiColors.shellCharcoal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Layout: ${_layoutSummary(state.layoutConfig)}',
                style: AdiyogiTextStyles.uiMicro(
                  context,
                ).copyWith(color: AdiyogiColors.shellGreyBody),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AdiyogiColors.shellBorder),

        // Preview Canvas Box
        Expanded(
          child: Container(
            color: AdiyogiColors.shellBackground,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: state.previewMode == 'Desktop'
                    ? formMaxWidthForPreset(
                        state.themeConfig.formWidthPreset,
                        maxWidth ?? 1200,
                      )
                    : maxWidth,
                height: height,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AdiyogiColors.shellWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Scaffold(
                    backgroundColor: AdiyogiColors.shellBackground,
                    body: SingleChildScrollView(
                      padding: EdgeInsets.all(state.themeConfig.formPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedSwitcher(
                            duration: state.animConfig.duration,
                            switchInCurve: state.animConfig.curveWidget,
                            switchOutCurve:
                                state.animConfig.curveWidget.flipped,
                            transitionBuilder: (child, animation) =>
                                _buildTransition(
                                  child,
                                  animation,
                                  state.animConfig.transition,
                                ),
                            child: KeyedSubtree(
                              key: ValueKey(
                                '${state.wizardStep}_'
                                '${state.layoutConfig.presentationMode}_${state.layoutConfig.navigationStyle}_'
                                '${state.layoutConfig.arrangementMode}_${state.layoutConfig.logicMode}_'
                                '${state.layoutConfig.layoutType}_${state.layoutConfig.navStyle}_'
                                '${state.layoutConfig.columns}_${state.previewMode}_${state.skeletonMode}',
                              ),
                              child: state.wizardStep == 1
                                  ? _UnifiedLayoutPreview(
                                      config: state.layoutConfig,
                                      schema: _schema,
                                      values: state.formValues,
                                      onValueChanged: notifier.updateFormValue,
                                    )
                                  : _renderActiveLayout(state, notifier),
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
          ),
        ),
      ],
    );
  }

  Widget _renderActiveLayout(
    FormBuilderState state,
    FormBuilderNotifier notifier,
  ) {
    final values = state.formValues;
    final callback = notifier.updateFormValue;
    final layoutId = state.selectedLayoutId;

    switch (layoutId) {
      case 'classic':
        return ClassicLongForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'collapsible':
        return CollapsibleSectionsForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'accordion_single':
        return AccordionSingleOpenForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'two_col':
        return TwoColumnForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'three_col':
        return ThreeColumnGridForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'wizard_section':
        return SectionPerPageWizard(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'wizard_question':
        return QuestionPerPageWizard(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'wizard_hybrid':
        return HybridWizard(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'wizard_mobile':
        return FullScreenMobileWizard(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'wizard_swipe':
        return SwipeCardWizard(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_left':
        return LeftSidebarNavigationForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_right':
        return RightSidebarNavigationForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_top':
        return TopStepNavigationForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_tabs':
        return TabsLayoutForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_breadcrumb':
        return BreadcrumbNavigationLayout(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_horizontal':
        return HorizontalProgressStepperForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_vertical':
        return VerticalProgressStepperForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_percent':
        return PercentageCompletionForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_checklist':
        return ChecklistCompletionForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'card_question':
        return QuestionCardForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'card_section':
        return SectionCardForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'kanban_sections':
        return KanbanStyleFormSections(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'accordion_multiple':
        return AccordionMultipleOpenForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'nav_tree':
        return TreeNavigationForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_bar':
        return ProgressBarForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'prog_step':
        return StepIndicatorForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_conversational':
      case 'conversational':
        return ConversationalForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_chat':
      case 'chatStyle':
        return ChatStyleForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_drawer':
      case 'drawerStyle':
        return DrawerForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_modal':
      case 'modalStyle':
        return ModalForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_conditional':
        return ConditionalDynamicForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      case 'adv_review':
      case 'reviewSubmit':
        return ReviewBeforeSubmitLayout(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
      default:
        return ClassicLongForm(
          schema: _schema,
          formValues: values,
          onValueChanged: callback,
        );
    }
  }

  Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    PageTransitionPreset transition,
  ) {
    switch (transition) {
      case PageTransitionPreset.none:
        return child;
      case PageTransitionPreset.fade:
        return FadeTransition(opacity: animation, child: child);
      case PageTransitionPreset.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case PageTransitionPreset.scale:
        return ScaleTransition(scale: animation, child: child);
      case PageTransitionPreset.push:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.14, 0.02),
            end: Offset.zero,
          ).animate(animation),
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

class _LayoutConfigurationPanel extends StatelessWidget {
  final FormLayoutConfig layoutConfig;
  final String selectedLayoutId;
  final void Function(FormLayoutConfig config, String layoutId)
  onLayoutConfigChanged;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _LayoutConfigurationPanel({
    required this.layoutConfig,
    required this.selectedLayoutId,
    required this.onLayoutConfigChanged,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      _ConfigGroup(
        title: 'Presentation',
        subtitle: 'How the form is surfaced.',
        options: [
          _ConfigOption(
            label: 'Page',
            description: 'Full-page form experience',
            icon: Icons.web_outlined,
            value: PresentationMode.page,
          ),
          _ConfigOption(
            label: 'Modal',
            description: 'Popup workflow',
            icon: Icons.crop_square_outlined,
            value: PresentationMode.modal,
          ),
          _ConfigOption(
            label: 'Drawer',
            description: 'Side panel form',
            icon: Icons.view_sidebar_outlined,
            value: PresentationMode.drawer,
          ),
          _ConfigOption(
            label: 'Embedded',
            description: 'Inside existing page',
            icon: Icons.view_quilt_outlined,
            value: PresentationMode.embedded,
          ),
        ],
      ),
      _ConfigGroup(
        title: 'Navigation',
        subtitle: 'How users move through the form.',
        options: [
          _ConfigOption(
            label: 'Scroll',
            description: 'Single continuous page',
            icon: Icons.swipe,
            value: NavigationStyle.scroll,
          ),
          _ConfigOption(
            label: 'Steps',
            description: 'Multi-step wizard',
            icon: Icons.view_day_outlined,
            value: NavigationStyle.nextPrevious,
          ),
          _ConfigOption(
            label: 'Tabs',
            description: 'Section switching',
            icon: Icons.tab,
            value: NavigationStyle.topTabs,
          ),
          _ConfigOption(
            label: 'Sidebar',
            description: 'Navigation-based workflow',
            icon: Icons.menu_open,
            value: NavigationStyle.leftSidebar,
          ),
          _ConfigOption(
            label: 'Accordion',
            description: 'Expandable sections',
            icon: Icons.unfold_more,
            value: NavigationStyle.accordion,
          ),
          _ConfigOption(
            label: 'Chat',
            description: 'Conversation style',
            icon: Icons.chat_bubble_outline,
            value: NavigationStyle.chat,
          ),
        ],
      ),
      _ConfigGroup(
        title: 'Arrangement',
        subtitle: 'How fields are placed on the canvas.',
        options: [
          _ConfigOption(
            label: 'Stack',
            description: 'Vertical fields',
            icon: Icons.vertical_align_top,
            value: ArrangementMode.stack,
          ),
          _ConfigOption(
            label: 'Grid',
            description: 'Multi-column layout',
            icon: Icons.grid_view,
            value: ArrangementMode.grid,
          ),
          _ConfigOption(
            label: 'Columns',
            description: 'Two-column layout',
            icon: Icons.view_column_outlined,
            value: ArrangementMode.columns,
          ),
          _ConfigOption(
            label: 'Cards',
            description: 'Card-based grouping',
            icon: Icons.space_dashboard_outlined,
            value: ArrangementMode.cards,
          ),
          _ConfigOption(
            label: 'Canvas',
            description: 'Free positioning',
            icon: Icons.design_services_outlined,
            value: ArrangementMode.canvas,
          ),
        ],
      ),
      _ConfigGroup(
        title: 'Logic',
        subtitle: 'How the form behaves.',
        options: [
          _ConfigOption(
            label: 'Linear',
            description: 'Fixed order',
            icon: Icons.timeline,
            value: LogicMode.linear,
          ),
          _ConfigOption(
            label: 'Conditional',
            description: 'Show or hide answers',
            icon: Icons.rule,
            value: LogicMode.conditional,
          ),
          _ConfigOption(
            label: 'Branching',
            description: 'Different paths',
            icon: Icons.alt_route,
            value: LogicMode.branching,
          ),
          _ConfigOption(
            label: 'Dynamic',
            description: 'Adaptive behavior',
            icon: Icons.auto_awesome,
            value: LogicMode.dynamic,
          ),
        ],
      ),
    ];

    return Container(
      width: 440,
      color: AdiyogiColors.shellWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Form Layout',
                  style: AdiyogiTextStyles.sectionHeading(
                    context,
                  ).copyWith(fontSize: 18, color: AdiyogiColors.shellCharcoal),
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure how your form appears, navigates, and behaves.',
                  style: AdiyogiTextStyles.bodyMedium(context),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SummaryPill(
                      label: 'Presentation',
                      value: _enumName(layoutConfig.presentationMode),
                    ),
                    _SummaryPill(
                      label: 'Navigation',
                      value: _enumName(layoutConfig.navigationStyle),
                    ),
                    _SummaryPill(
                      label: 'Arrangement',
                      value: _enumName(layoutConfig.arrangementMode),
                    ),
                    _SummaryPill(
                      label: 'Logic',
                      value: _enumName(layoutConfig.logicMode),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AdiyogiColors.shellBorder),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final group in sections) ...[
                    _ConfigGroupCard(
                      group: group,
                      current: layoutConfig,
                      onChanged: (next) => onLayoutConfigChanged(
                        next,
                        _layoutPresetIdForConfig(next),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AdiyogiColors.shellCharcoal,
                      side: const BorderSide(color: AdiyogiColors.shellBorder),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdiyogiColors.shellCharcoal,
                      foregroundColor: AdiyogiColors.shellWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Layout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigGroup {
  final String title;
  final String subtitle;
  final List<_ConfigOption> options;

  const _ConfigGroup({
    required this.title,
    required this.subtitle,
    required this.options,
  });
}

class _ConfigOption {
  final String label;
  final String description;
  final IconData icon;
  final Object value;

  const _ConfigOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
  });
}

class _ConfigGroupCard extends StatelessWidget {
  final _ConfigGroup group;
  final FormLayoutConfig current;
  final ValueChanged<FormLayoutConfig> onChanged;

  const _ConfigGroupCard({
    required this.group,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdiyogiColors.shellBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdiyogiColors.shellBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.title, style: AdiyogiTextStyles.labelLarge(context)),
          const SizedBox(height: 4),
          Text(group.subtitle, style: AdiyogiTextStyles.uiMicro(context)),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width > 360 ? 2 : 1;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final option in group.options)
                    SizedBox(
                      width: columns == 2 ? (width - 10) / 2 : width,
                      child: _SelectableOptionCard(
                        option: option,
                        selected: _isSelected(option),
                        disabled: !_isCompatible(option),
                        reason: _compatibilityReason(option),
                        onTap: () => onChanged(_updatedConfig(option)),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSelected(_ConfigOption option) {
    if (option.value is PresentationMode)
      return current.presentationMode == option.value;
    if (option.value is NavigationStyle)
      return current.navigationStyle == option.value;
    if (option.value is ArrangementMode)
      return current.arrangementMode == option.value;
    if (option.value is LogicMode) return current.logicMode == option.value;
    return false;
  }

  bool _isCompatible(_ConfigOption option) {
    final preview = _updatedConfig(option);
    if (preview.navigationStyle == NavigationStyle.chat &&
        preview.presentationMode == PresentationMode.modal)
      return false;
    if (preview.presentationMode == PresentationMode.drawer &&
        preview.navigationStyle == NavigationStyle.topTabs)
      return false;
    if (preview.arrangementMode == ArrangementMode.canvas &&
        preview.logicMode == LogicMode.linear)
      return false;
    if (preview.navigationStyle == NavigationStyle.accordion &&
        preview.logicMode == LogicMode.branching)
      return false;
    return true;
  }

  String? _compatibilityReason(_ConfigOption option) {
    final preview = _updatedConfig(option);
    if (preview.navigationStyle == NavigationStyle.chat &&
        preview.presentationMode == PresentationMode.modal) {
      return 'Chat works best in page or embedded mode.';
    }
    if (preview.presentationMode == PresentationMode.drawer &&
        preview.navigationStyle == NavigationStyle.topTabs) {
      return 'Tabs are too dense for drawer workflows.';
    }
    if (preview.arrangementMode == ArrangementMode.canvas &&
        preview.logicMode == LogicMode.linear) {
      return 'Canvas usually needs dynamic or branching logic.';
    }
    if (preview.navigationStyle == NavigationStyle.accordion &&
        preview.logicMode == LogicMode.branching) {
      return 'Accordion navigation should stay visually simple.';
    }
    return null;
  }

  FormLayoutConfig _updatedConfig(_ConfigOption option) {
    if (option.value is PresentationMode) {
      return current.copyWith(
        presentationMode: option.value as PresentationMode,
      );
    }
    if (option.value is NavigationStyle) {
      return current.copyWith(navigationStyle: option.value as NavigationStyle);
    }
    if (option.value is ArrangementMode) {
      return current.copyWith(arrangementMode: option.value as ArrangementMode);
    }
    if (option.value is LogicMode) {
      return current.copyWith(logicMode: option.value as LogicMode);
    }
    return current;
  }
}

class _SelectableOptionCard extends StatelessWidget {
  final _ConfigOption option;
  final bool selected;
  final bool disabled;
  final String? reason;
  final VoidCallback onTap;

  const _SelectableOptionCard({
    required this.option,
    required this.selected,
    required this.disabled,
    required this.reason,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AdiyogiColors.shellCharcoal
        : AdiyogiColors.shellBorder;
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AdiyogiColors.shellWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AdiyogiColors.shellGreyBody.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    option.icon,
                    size: 18,
                    color: selected
                        ? AdiyogiColors.shellCharcoal
                        : AdiyogiColors.shellGreyBody,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      option.label,
                      style: AdiyogiTextStyles.labelLarge(
                        context,
                      ).copyWith(fontSize: 14),
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: AdiyogiColors.shellCharcoal,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                option.description,
                style: AdiyogiTextStyles.uiMicro(context),
              ),
              if (disabled && reason != null) ...[
                const SizedBox(height: 6),
                Text(
                  reason!,
                  style: AdiyogiTextStyles.uiMicro(
                    context,
                  ).copyWith(color: AdiyogiColors.shellGreyBody),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _enumName(Object value) {
  final text = value.toString();
  return text.split('.').last;
}

String _layoutPresetIdForConfig(FormLayoutConfig config) {
  if (config.navigationStyle == NavigationStyle.chat) return 'adv_chat';
  if (config.presentationMode == PresentationMode.drawer) return 'adv_drawer';
  if (config.presentationMode == PresentationMode.modal) return 'adv_modal';
  if (config.navigationStyle == NavigationStyle.leftSidebar) return 'nav_left';
  if (config.navigationStyle == NavigationStyle.rightSidebar)
    return 'nav_right';
  if (config.navigationStyle == NavigationStyle.topTabs) return 'nav_tabs';
  if (config.navigationStyle == NavigationStyle.accordion)
    return 'accordion_multiple';
  if (config.navigationStyle == NavigationStyle.breadcrumb)
    return 'nav_breadcrumb';
  if (config.navigationStyle == NavigationStyle.stepIndicator)
    return 'prog_step';
  if (config.navigationStyle == NavigationStyle.progressBar) return 'prog_bar';
  if (config.navigationStyle == NavigationStyle.percentage)
    return 'prog_percent';
  if (config.navigationStyle == NavigationStyle.checklist)
    return 'prog_checklist';
  if (config.arrangementMode == ArrangementMode.cards) return 'card_section';
  if (config.arrangementMode == ArrangementMode.grid) return 'three_col';
  if (config.arrangementMode == ArrangementMode.columns) return 'two_col';
  if (config.navigationStyle == NavigationStyle.nextPrevious)
    return 'wizard_section';
  return 'classic';
}

class _SummaryPill extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AdiyogiColors.shellBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AdiyogiColors.shellBorder),
      ),
      child: Text('$label: $value', style: AdiyogiTextStyles.uiMicro(context)),
    );
  }
}

class _UnifiedLayoutPreview extends StatelessWidget {
  final FormLayoutConfig config;
  final FormSchema schema;
  final Map<String, dynamic> values;
  final void Function(String, dynamic) onValueChanged;

  const _UnifiedLayoutPreview({
    required this.config,
    required this.schema,
    required this.values,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeSection = schema.sections.isNotEmpty
        ? schema.sections.first
        : null;
    final arrangement = config.arrangementMode;
    final logic = config.logicMode;

    Widget body;
    if (config.navigationStyle == NavigationStyle.chat) {
      body = _buildChatPreview(context);
    } else if (config.presentationMode == PresentationMode.embedded) {
      body = _buildEmbeddedPreview(context, activeSection, arrangement, logic);
    } else if (config.presentationMode == PresentationMode.drawer) {
      body = _buildDrawerPreview(context, activeSection);
    } else if (config.presentationMode == PresentationMode.modal) {
      body = _buildModalPreview(context, activeSection);
    } else if (config.navigationStyle == NavigationStyle.leftSidebar ||
        config.navigationStyle == NavigationStyle.rightSidebar) {
      body = _buildSidebarPreview(context, activeSection);
    } else if (config.navigationStyle == NavigationStyle.topTabs) {
      body = _buildTabsPreview(context, activeSection);
    } else if (config.navigationStyle == NavigationStyle.accordion) {
      body = _buildAccordionPreview(context, activeSection);
    } else if (config.navigationStyle == NavigationStyle.nextPrevious ||
        config.navigationStyle == NavigationStyle.stepIndicator) {
      body = _buildStepsPreview(context, activeSection);
    } else {
      body = _buildScrollPreview(context, activeSection, arrangement, logic);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: body,
    );
  }

  Widget _buildShell(
    BuildContext context, {
    required Widget child,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AdiyogiTextStyles.sectionHeading(context)),
        const SizedBox(height: 4),
        Text(subtitle, style: AdiyogiTextStyles.uiMicro(context)),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildScrollPreview(
    BuildContext context,
    FormSection? activeSection,
    ArrangementMode arrangement,
    LogicMode logic,
  ) {
    return _buildShell(
      context,
      title: 'Page Preview',
      subtitle: 'Continuous form flow',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (config.navigationStyle == NavigationStyle.nextPrevious ||
              config.navigationStyle == NavigationStyle.stepIndicator)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Step 2 of 5',
                style: AdiyogiTextStyles.labelMedium(context),
              ),
            ),
          if (activeSection != null)
            SectionCard(
              title: activeSection.title,
              description: activeSection.description,
              child: _buildArrangementBody(
                context,
                activeSection,
                arrangement,
                logic,
              ),
            ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(onPressed: () {}, child: const Text('Back')),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: () {}, child: const Text('Next')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmbeddedPreview(
    BuildContext context,
    FormSection? activeSection,
    ArrangementMode arrangement,
    LogicMode logic,
  ) {
    return _buildShell(
      context,
      title: 'Embedded Preview',
      subtitle: 'Form mounted inside an existing page',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AdiyogiColors.shellBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AdiyogiColors.shellBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Existing page content',
              style: AdiyogiTextStyles.uiMicro(context),
            ),
            const SizedBox(height: 12),
            if (activeSection != null)
              SectionCard(
                title: activeSection.title,
                description: activeSection.description,
                child: _buildArrangementBody(
                  context,
                  activeSection,
                  arrangement,
                  logic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerPreview(BuildContext context, FormSection? activeSection) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AdiyogiColors.shellBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AdiyogiColors.shellBorder),
            ),
            child: const SizedBox.expand(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 280,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AdiyogiColors.shellWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AdiyogiColors.shellBorder),
                boxShadow: [
                  BoxShadow(
                    color: AdiyogiColors.shellGreyBody.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Main Application',
                    style: AdiyogiTextStyles.labelLarge(context),
                  ),
                  const SizedBox(height: 12),
                  ...schema.sections
                      .take(4)
                      .map(
                        (sec) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            sec.title,
                            style: AdiyogiTextStyles.bodyMedium(context),
                          ),
                        ),
                      ),
                  const SizedBox(height: 12),
                  if (activeSection != null)
                    SectionCard(
                      title: activeSection.title,
                      description: activeSection.description,
                      child: _buildArrangementBody(
                        context,
                        activeSection,
                        config.arrangementMode,
                        config.logicMode,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalPreview(BuildContext context, FormSection? activeSection) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Material(
          color: AdiyogiColors.shellWhite,
          borderRadius: BorderRadius.circular(20),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: activeSection == null
                ? const SizedBox.shrink()
                : SectionCard(
                    title: activeSection.title,
                    description: 'Modal workspace',
                    child: _buildArrangementBody(
                      context,
                      activeSection,
                      config.arrangementMode,
                      config.logicMode,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarPreview(
    BuildContext context,
    FormSection? activeSection,
  ) {
    final sectionTitles = schema.sections.take(4).map((s) => s.title).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdiyogiColors.shellBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AdiyogiColors.shellBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final title in sectionTitles)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: AdiyogiTextStyles.bodyMedium(context),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: activeSection == null
              ? const SizedBox.shrink()
              : SectionCard(
                  title: activeSection.title,
                  description: activeSection.description,
                  child: _buildArrangementBody(
                    context,
                    activeSection,
                    config.arrangementMode,
                    config.logicMode,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTabsPreview(BuildContext context, FormSection? activeSection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: schema.sections.take(4).map((s) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AdiyogiColors.shellWhite,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AdiyogiColors.shellBorder),
              ),
              child: Text(s.title, style: AdiyogiTextStyles.uiMicro(context)),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (activeSection != null)
          SectionCard(
            title: activeSection.title,
            description: activeSection.description,
            child: _buildArrangementBody(
              context,
              activeSection,
              config.arrangementMode,
              config.logicMode,
            ),
          ),
      ],
    );
  }

  Widget _buildAccordionPreview(
    BuildContext context,
    FormSection? activeSection,
  ) {
    return Column(
      children: [
        for (final section in schema.sections.take(3))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SectionCard(
              title: section.title,
              description: section.description,
              child: _buildArrangementBody(
                context,
                section,
                config.arrangementMode,
                config.logicMode,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStepsPreview(BuildContext context, FormSection? activeSection) {
    if (activeSection == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Step 2 of 5', style: AdiyogiTextStyles.labelMedium(context)),
        const SizedBox(height: 12),
        SectionCard(
          title: activeSection.title,
          description: activeSection.description,
          child: _buildArrangementBody(
            context,
            activeSection,
            config.arrangementMode,
            config.logicMode,
          ),
        ),
      ],
    );
  }

  Widget _buildChatPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assistant', style: AdiyogiTextStyles.labelLarge(context)),
        const SizedBox(height: 8),
        _bubble(context, 'What is your name?', alignLeft: true),
        const SizedBox(height: 8),
        _bubble(context, 'John', alignLeft: false),
        const SizedBox(height: 8),
        _bubble(context, 'What is your email?', alignLeft: true),
      ],
    );
  }

  Widget _bubble(BuildContext context, String text, {required bool alignLeft}) {
    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: alignLeft
              ? AdiyogiColors.shellWhite
              : AdiyogiColors.shellBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AdiyogiColors.shellBorder),
        ),
        child: Text(text, style: AdiyogiTextStyles.bodyMedium(context)),
      ),
    );
  }

  Widget _buildArrangementBody(
    BuildContext context,
    FormSection section,
    ArrangementMode arrangement,
    LogicMode logic,
  ) {
    final questionWidgets = section.questions.take(4).map((q) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AdiyogiColors.shellWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AdiyogiColors.shellBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q.label, style: AdiyogiTextStyles.labelMedium(context)),
            const SizedBox(height: 10),
            TextInputField(
              value: values[q.id]?.toString() ?? '',
              placeholder: q.placeholder,
              onChanged: (value) => onValueChanged(q.id, value),
            ),
          ],
        ),
      );
    }).toList();

    late final Widget content;
    switch (arrangement) {
      case ArrangementMode.grid:
        content = Wrap(
          spacing: 12,
          runSpacing: 12,
          children: questionWidgets
              .map((w) => SizedBox(width: 220, child: w))
              .toList(),
        );
      case ArrangementMode.columns:
        final leftCount = (questionWidgets.length / 2).ceil();
        content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(children: questionWidgets.take(leftCount).toList()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(children: questionWidgets.skip(leftCount).toList()),
            ),
          ],
        );
      case ArrangementMode.cards:
        content = Column(
          children: questionWidgets
              .map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                ),
              )
              .toList(),
        );
      case ArrangementMode.canvas:
        content = SizedBox(
          height: 220,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: 180,
                child: questionWidgets.isNotEmpty
                    ? questionWidgets.first
                    : const SizedBox(),
              ),
              Positioned(
                right: 0,
                top: 24,
                width: 180,
                child: questionWidgets.length > 1
                    ? questionWidgets[1]
                    : const SizedBox(),
              ),
              Positioned(
                left: 40,
                bottom: 0,
                width: 220,
                child: questionWidgets.length > 2
                    ? questionWidgets[2]
                    : const SizedBox(),
              ),
            ],
          ),
        );
      case ArrangementMode.stack:
        content = Column(
          children: questionWidgets
              .map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                ),
              )
              .toList(),
        );
    }

    if (logic == LogicMode.conditional ||
        logic == LogicMode.branching ||
        logic == LogicMode.dynamic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AdiyogiColors.shellBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AdiyogiColors.shellBorder),
            ),
            child: Text(
              _enumName(logic),
              style: AdiyogiTextStyles.uiMicro(context),
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      );
    }

    return content;
  }
}
