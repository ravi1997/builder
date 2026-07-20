enum FormLayoutType {
  classic,
  collapsible,
  accordionSingle,
  accordionMultiple,
  sectionCards,
  twoColumn,
  threeColumn,
  wizardSection,
  wizardQuestion,
  wizardHybrid,
  wizardMobile,
  wizardSwipe,
  navLeft,
  navRight,
  navTop,
  navBreadcrumb,
  navTree,
  progBar,
  progPercent,
  progStep,
  progChecklist,
  conversational,
  chatStyle,
  drawerStyle,
  modalStyle,
  reviewSubmit,
}

enum NavigationStyle {
  none,
  scroll,
  nextPrevious,
  topTabs,
  leftSidebar,
  rightSidebar,
  accordion,
  chat,
  breadcrumb,
  stepIndicator,
  progressBar,
  percentage,
  checklist,
}

enum PresentationMode {
  page,
  modal,
  drawer,
  embedded,
}

enum ArrangementMode {
  stack,
  grid,
  columns,
  cards,
  canvas,
}

enum LogicMode {
  linear,
  conditional,
  branching,
  dynamic,
}

class FormLayoutConfig {
  final PresentationMode presentationMode;
  final NavigationStyle navigationStyle;
  final ArrangementMode arrangementMode;
  final LogicMode logicMode;
  final FormLayoutType layoutType;
  final NavigationStyle navStyle;
  final int columns;
  final int numSections;
  final int questionsPerSection;

  const FormLayoutConfig({
    this.presentationMode = PresentationMode.page,
    this.navigationStyle = NavigationStyle.scroll,
    this.arrangementMode = ArrangementMode.stack,
    this.logicMode = LogicMode.linear,
    this.layoutType = FormLayoutType.classic,
    this.navStyle = NavigationStyle.none,
    this.columns = 1,
    this.numSections = 3,
    this.questionsPerSection = 3,
  });

  FormLayoutConfig copyWith({
    PresentationMode? presentationMode,
    NavigationStyle? navigationStyle,
    ArrangementMode? arrangementMode,
    LogicMode? logicMode,
    FormLayoutType? layoutType,
    NavigationStyle? navStyle,
    int? columns,
    int? numSections,
    int? questionsPerSection,
  }) {
    return FormLayoutConfig(
      presentationMode: presentationMode ?? this.presentationMode,
      navigationStyle: navigationStyle ?? this.navigationStyle,
      arrangementMode: arrangementMode ?? this.arrangementMode,
      logicMode: logicMode ?? this.logicMode,
      layoutType: layoutType ?? this.layoutType,
      navStyle: navStyle ?? this.navStyle,
      columns: columns ?? this.columns,
      numSections: numSections ?? this.numSections,
      questionsPerSection: questionsPerSection ?? this.questionsPerSection,
    );
  }
}
