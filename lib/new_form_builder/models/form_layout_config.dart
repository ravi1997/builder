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
  nextPrevious,
  topTabs,
  leftSidebar,
  rightSidebar,
  breadcrumb,
  stepIndicator,
  progressBar,
  percentage,
  checklist,
}

class FormLayoutConfig {
  final FormLayoutType layoutType;
  final NavigationStyle navStyle;
  final int columns;
  final int numSections;
  final int questionsPerSection;

  const FormLayoutConfig({
    this.layoutType = FormLayoutType.classic,
    this.navStyle = NavigationStyle.none,
    this.columns = 1,
    this.numSections = 3,
    this.questionsPerSection = 3,
  });

  FormLayoutConfig copyWith({
    FormLayoutType? layoutType,
    NavigationStyle? navStyle,
    int? columns,
    int? numSections,
    int? questionsPerSection,
  }) {
    return FormLayoutConfig(
      layoutType: layoutType ?? this.layoutType,
      navStyle: navStyle ?? this.navStyle,
      columns: columns ?? this.columns,
      numSections: numSections ?? this.numSections,
      questionsPerSection: questionsPerSection ?? this.questionsPerSection,
    );
  }
}
