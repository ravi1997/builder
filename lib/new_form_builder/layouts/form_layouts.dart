import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';

List<FormQuestion> _allQuestions(FormSchema schema) {
  return schema.sections.expand((sec) => sec.questions).toList();
}

double _completionFraction(FormSchema schema, Map<String, dynamic> formValues) {
  final questions = _allQuestions(schema);
  if (questions.isEmpty) return 0;

  var filled = 0;
  for (final question in questions) {
    final value = formValues[question.id];
    if (value != null && value.toString().trim().isNotEmpty) {
      filled++;
    }
  }

  return filled / questions.length;
}

bool _sectionIsComplete(FormSection section, Map<String, dynamic> formValues) {
  for (final question in section.questions) {
    if (!question.required) continue;
    final value = formValues[question.id];
    if (value == null || value.toString().trim().isEmpty) {
      return false;
    }
  }
  return true;
}

int _filledQuestionCount(FormSection section, Map<String, dynamic> formValues) {
  var count = 0;
  for (final question in section.questions) {
    final value = formValues[question.id];
    if (value != null && value.toString().trim().isNotEmpty) {
      count++;
    }
  }
  return count;
}

FormQuestion? _firstUnansweredQuestion(FormSchema schema, Map<String, dynamic> formValues) {
  for (final question in _allQuestions(schema)) {
    final value = formValues[question.id];
    if (value == null || value.toString().trim().isEmpty) {
      return question;
    }
  }
  return null;
}

class ClassicLongForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ClassicLongForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schema.sections.length,
      itemBuilder: (context, index) {
        final sec = schema.sections[index];
        return SectionCard(
          title: sec.title,
          description: sec.description,
          child: FormSectionWidget(
            section: sec,
            formValues: formValues,
            onValueChanged: onValueChanged,
          ),
        );
      },
    );
  }
}

class CollapsibleSectionsForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const CollapsibleSectionsForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<CollapsibleSectionsForm> createState() => _CollapsibleSectionsFormState();
}

class _CollapsibleSectionsFormState extends State<CollapsibleSectionsForm> {
  late Map<String, bool> _expandedState;

  @override
  void initState() {
    super.initState();
    _expandedState = {for (var sec in widget.schema.sections) sec.id: true};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.schema.sections.map((sec) {
        final isExpanded = _expandedState[sec.id] ?? false;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: AdiyogiColors.shellWhite,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AdiyogiColors.shellBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(sec.title, style: AdiyogiTextStyles.labelLarge(context)),
                  subtitle: Text(sec.description, style: AdiyogiTextStyles.uiMicro(context)),
                  trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onTap: () {
                    setState(() {
                      _expandedState[sec.id] = !isExpanded;
                    });
                  },
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FormSectionWidget(
                      section: sec,
                      formValues: widget.formValues,
                      onValueChanged: widget.onValueChanged,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AccordionSingleOpenForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const AccordionSingleOpenForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<AccordionSingleOpenForm> createState() => _AccordionSingleOpenFormState();
}

class _AccordionSingleOpenFormState extends State<AccordionSingleOpenForm> {
  String? _openSectionId;

  @override
  void initState() {
    super.initState();
    if (widget.schema.sections.isNotEmpty) {
      _openSectionId = widget.schema.sections.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.schema.sections.map((sec) {
        final isExpanded = _openSectionId == sec.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: AdiyogiColors.shellWhite,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AdiyogiColors.shellBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(sec.title, style: AdiyogiTextStyles.labelLarge(context)),
                  subtitle: Text(sec.description, style: AdiyogiTextStyles.uiMicro(context)),
                  trailing: Icon(isExpanded ? Icons.radio_button_checked : Icons.radio_button_off),
                  onTap: () {
                    setState(() {
                      _openSectionId = isExpanded ? null : sec.id;
                    });
                  },
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FormSectionWidget(
                      section: sec,
                      formValues: widget.formValues,
                      onValueChanged: widget.onValueChanged,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TwoColumnForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const TwoColumnForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: schema.sections.map((sec) {
        return SectionCard(
          title: sec.title,
          description: sec.description,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: sec.questions.map((q) {
                  return SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: FormQuestionWidget(
                      question: q,
                      value: formValues[q.id],
                      onChanged: (val) => onValueChanged(q.id, val),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class ThreeColumnGridForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ThreeColumnGridForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: schema.sections.map((sec) {
        return SectionCard(
          title: sec.title,
          description: sec.description,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: sec.questions.map((q) {
                  return SizedBox(
                    width: (constraints.maxWidth - 24) / 3,
                    child: FormQuestionWidget(
                      question: q,
                      value: formValues[q.id],
                      onChanged: (val) => onValueChanged(q.id, val),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class SectionPerPageWizard extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const SectionPerPageWizard({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<SectionPerPageWizard> createState() => _SectionPerPageWizardState();
}

class _SectionPerPageWizardState extends State<SectionPerPageWizard> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final sec = widget.schema.sections[_currentStep];
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / widget.schema.sections.length,
          color: AdiyogiColors.shellCharcoal,
          backgroundColor: AdiyogiColors.surfaceSubtle,
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: sec.title,
          description: sec.description,
          child: FormSectionWidget(
            section: sec,
            formValues: widget.formValues,
            onValueChanged: widget.onValueChanged,
          ),
        ),
        WizardNavigationRow(
          currentStep: _currentStep,
          totalSteps: widget.schema.sections.length,
          onPrevious: () => setState(() => _currentStep--),
          onNext: () => setState(() => _currentStep++),
        ),
      ],
    );
  }
}

class QuestionPerPageWizard extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const QuestionPerPageWizard({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<QuestionPerPageWizard> createState() => _QuestionPerPageWizardState();
}

class _QuestionPerPageWizardState extends State<QuestionPerPageWizard> {
  int _currentQuestionIndex = 0;

  List<FormQuestion> get allQuestions =>
      widget.schema.sections.expand((sec) => sec.questions).toList();

  @override
  Widget build(BuildContext context) {
    final questions = allQuestions;
    if (questions.isEmpty) return const Text('No questions');
    final question = questions[_currentQuestionIndex];

    return Column(
      children: [
        Text(
          'Question ${_currentQuestionIndex + 1} of ${questions.length}',
          style: AdiyogiTextStyles.uiMicro(context),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / questions.length,
          color: AdiyogiColors.shellCharcoal,
          backgroundColor: AdiyogiColors.surfaceSubtle,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AdiyogiColors.shellWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AdiyogiColors.shellBorder),
          ),
          child: FormQuestionWidget(
            question: question,
            value: widget.formValues[question.id],
            onChanged: (val) => widget.onValueChanged(question.id, val),
          ),
        ),
        const SizedBox(height: 24),
        WizardNavigationRow(
          currentStep: _currentQuestionIndex,
          totalSteps: questions.length,
          onPrevious: () => setState(() => _currentQuestionIndex--),
          onNext: () => setState(() => _currentQuestionIndex++),
          nextLabel: 'Continue',
        ),
      ],
    );
  }
}

class HybridWizard extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const HybridWizard({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<HybridWizard> createState() => _HybridWizardState();
}

class _HybridWizardState extends State<HybridWizard> {
  int _currentStep = 0;

  // Let's bundle sections two at a time
  int get stepCount => (widget.schema.sections.length / 2).ceil();

  @override
  Widget build(BuildContext context) {
    final int secIndex1 = _currentStep * 2;
    final int secIndex2 = _currentStep * 2 + 1;
    final sectionsToShow = <FormSection>[];
    if (secIndex1 < widget.schema.sections.length) sectionsToShow.add(widget.schema.sections[secIndex1]);
    if (secIndex2 < widget.schema.sections.length) sectionsToShow.add(widget.schema.sections[secIndex2]);

    return Column(
      children: [
        Text(
          'Step ${_currentStep + 1} of $stepCount (Hybrid View)',
          style: AdiyogiTextStyles.labelLarge(context),
        ),
        const SizedBox(height: 24),
        ...sectionsToShow.map((sec) => SectionCard(
              title: sec.title,
              description: sec.description,
              child: FormSectionWidget(
                section: sec,
                formValues: widget.formValues,
                onValueChanged: widget.onValueChanged,
              ),
            )),
        const SizedBox(height: 24),
        WizardNavigationRow(
          currentStep: _currentStep,
          totalSteps: stepCount,
          onPrevious: () => setState(() => _currentStep--),
          onNext: () => setState(() => _currentStep++),
          nextLabel: 'Next Step',
        ),
      ],
    );
  }
}

class FullScreenMobileWizard extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const FullScreenMobileWizard({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<FullScreenMobileWizard> createState() => _FullScreenMobileWizardState();
}

class _FullScreenMobileWizardState extends State<FullScreenMobileWizard> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final sec = widget.schema.sections[_index];
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 375),
        decoration: BoxDecoration(
          border: const Border.fromBorderSide(BorderSide(color: AdiyogiColors.shellBorder, width: 4)),
          borderRadius: BorderRadius.circular(32),
          color: AdiyogiColors.shellWhite,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.signal_cellular_alt, size: 16),
                Text(sec.title, style: AdiyogiTextStyles.uiMicro(context)),
                const Icon(Icons.battery_5_bar, size: 16),
              ],
            ),
            const Divider(height: 24),
            Text(sec.title, style: AdiyogiTextStyles.sectionHeading(context)),
            const SizedBox(height: 16),
            FormSectionWidget(
              section: sec,
              formValues: widget.formValues,
              onValueChanged: widget.onValueChanged,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                if (_index > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _index--),
                      child: const Text('Back'),
                    ),
                  ),
                if (_index > 0) const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _index < widget.schema.sections.length - 1
                        ? () => setState(() => _index++)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdiyogiColors.shellCharcoal,
                      foregroundColor: AdiyogiColors.shellWhite,
                    ),
                    child: Text(_index < widget.schema.sections.length - 1 ? 'Next' : 'Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeCardWizard extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const SwipeCardWizard({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<SwipeCardWizard> createState() => _SwipeCardWizardState();
}

class _SwipeCardWizardState extends State<SwipeCardWizard> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Swipeable steps - Page ${_currentPage + 1} of ${widget.schema.sections.length}',
          style: AdiyogiTextStyles.labelMedium(context),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: widget.schema.sections.length,
            itemBuilder: (context, idx) {
              final sec = widget.schema.sections[idx];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sec.title, style: AdiyogiTextStyles.cardHeading(context)),
                        const SizedBox(height: 16),
                        FormSectionWidget(
                          section: sec,
                          formValues: widget.formValues,
                          onValueChanged: widget.onValueChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _currentPage > 0
                  ? () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)
                  : null,
            ),
            Row(
              children: List.generate(
                widget.schema.sections.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellBorder,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _currentPage < widget.schema.sections.length - 1
                  ? () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)
                  : null,
            ),
          ],
        )
      ],
    );
  }
}

class LeftSidebarNavigationForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const LeftSidebarNavigationForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<LeftSidebarNavigationForm> createState() => _LeftSidebarNavigationFormState();
}

class _LeftSidebarNavigationFormState extends State<LeftSidebarNavigationForm> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final activeSection = widget.schema.sections[_selectedIndex];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 160,
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            border: const Border(right: BorderSide(color: AdiyogiColors.shellBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.schema.sections.length, (idx) {
              final active = _selectedIndex == idx;
              return TextButton(
                onPressed: () => setState(() => _selectedIndex = idx),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: active ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                ),
                child: Text(
                  widget.schema.sections[idx].title,
                  style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.normal),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: SectionCard(
            title: activeSection.title,
            description: activeSection.description,
            child: FormSectionWidget(
              section: activeSection,
              formValues: widget.formValues,
              onValueChanged: widget.onValueChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class RightSidebarNavigationForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const RightSidebarNavigationForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<RightSidebarNavigationForm> createState() => _RightSidebarNavigationFormState();
}

class _RightSidebarNavigationFormState extends State<RightSidebarNavigationForm> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final activeSection = widget.schema.sections[_selectedIndex];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SectionCard(
            title: activeSection.title,
            description: activeSection.description,
            child: FormSectionWidget(
              section: activeSection,
              formValues: widget.formValues,
              onValueChanged: widget.onValueChanged,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Container(
          width: 160,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            border: const Border(left: BorderSide(color: AdiyogiColors.shellBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.schema.sections.length, (idx) {
              final active = _selectedIndex == idx;
              return TextButton(
                onPressed: () => setState(() => _selectedIndex = idx),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: active ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                ),
                child: Text(
                  widget.schema.sections[idx].title,
                  style: TextStyle(fontWeight: active ? FontWeight.bold : FontWeight.normal),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class TopStepNavigationForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const TopStepNavigationForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<TopStepNavigationForm> createState() => _TopStepNavigationFormState();
}

class _TopStepNavigationFormState extends State<TopStepNavigationForm> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final activeSection = widget.schema.sections[_selectedIndex];
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(widget.schema.sections.length, (idx) {
              final active = _selectedIndex == idx;
              return InkWell(
                onTap: () => setState(() => _selectedIndex = idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: active ? AdiyogiColors.shellCharcoal : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.schema.sections[idx].title,
                    style: TextStyle(
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: activeSection.title,
          description: activeSection.description,
          child: FormSectionWidget(
            section: activeSection,
            formValues: widget.formValues,
            onValueChanged: widget.onValueChanged,
          ),
        ),
      ],
    );
  }
}

class TabsLayoutForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const TabsLayoutForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<TabsLayoutForm> createState() => _TabsLayoutFormState();
}

class _TabsLayoutFormState extends State<TabsLayoutForm> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.schema.sections.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AdiyogiColors.shellCharcoal,
          unselectedLabelColor: AdiyogiColors.shellGreyBody,
          indicatorColor: AdiyogiColors.shellCharcoal,
          tabs: widget.schema.sections.map((sec) => Tab(text: sec.title)).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 380,
          child: TabBarView(
            controller: _tabController,
            children: widget.schema.sections.map((sec) {
              return SingleChildScrollView(
                child: SectionCard(
                  title: sec.title,
                  description: sec.description,
                  child: FormSectionWidget(
                    section: sec,
                    formValues: widget.formValues,
                    onValueChanged: widget.onValueChanged,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BreadcrumbNavigationLayout extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const BreadcrumbNavigationLayout({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<BreadcrumbNavigationLayout> createState() => _BreadcrumbNavigationLayoutState();
}

class _BreadcrumbNavigationLayoutState extends State<BreadcrumbNavigationLayout> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final active = widget.schema.sections[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Form', style: TextStyle(color: AdiyogiColors.shellGreyBody)),
            Icon(Icons.chevron_right, size: 16, color: AdiyogiColors.shellGreyBody),
            Text(active.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AdiyogiColors.shellCharcoal)),
          ],
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: active.title,
          description: active.description,
          child: FormSectionWidget(
            section: active,
            formValues: widget.formValues,
            onValueChanged: widget.onValueChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormNavigationButton(
              label: 'Previous',
              primary: false,
              onPressed: _index > 0 ? () => setState(() => _index--) : null,
            ),
            FormNavigationButton(
              label: _index < widget.schema.sections.length - 1 ? 'Next' : 'Finish',
              onPressed: _index < widget.schema.sections.length - 1 ? () => setState(() => _index++) : null,
            ),
          ],
        )
      ],
    );
  }
}

class HorizontalProgressStepperForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const HorizontalProgressStepperForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<HorizontalProgressStepperForm> createState() => _HorizontalProgressStepperFormState();
}

class _HorizontalProgressStepperFormState extends State<HorizontalProgressStepperForm> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final active = widget.schema.sections[_currentStep];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.schema.sections.length, (idx) {
            final activeStep = idx == _currentStep;
            final completed = idx < _currentStep;
            return Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: activeStep
                      ? AdiyogiColors.shellCharcoal
                      : (completed ? AdiyogiColors.shellBorder : AdiyogiColors.surfaceSubtle),
                  child: Text(
                    '${idx + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: activeStep || completed ? AdiyogiColors.shellWhite : AdiyogiColors.shellGreyBody,
                    ),
                  ),
                ),
                if (idx < widget.schema.sections.length - 1)
                  Container(
                    width: 30,
                    height: 2,
                    color: completed ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellBorder,
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: active.title,
          description: active.description,
          child: FormSectionWidget(
            section: active,
            formValues: widget.formValues,
            onValueChanged: widget.onValueChanged,
          ),
        ),
        WizardNavigationRow(
          currentStep: _currentStep,
          totalSteps: widget.schema.sections.length,
          onPrevious: () => setState(() => _currentStep--),
          onNext: () => setState(() => _currentStep++),
        ),
      ],
    );
  }
}

class VerticalProgressStepperForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const VerticalProgressStepperForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<VerticalProgressStepperForm> createState() => _VerticalProgressStepperFormState();
}

class _VerticalProgressStepperFormState extends State<VerticalProgressStepperForm> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(widget.schema.sections.length, (idx) {
            final activeStep = idx == _currentStep;
            final completed = idx < _currentStep;
            return Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: activeStep
                      ? AdiyogiColors.shellCharcoal
                      : (completed ? AdiyogiColors.shellBorder : AdiyogiColors.surfaceSubtle),
                  child: Text(
                    '${idx + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: activeStep || completed ? AdiyogiColors.shellWhite : AdiyogiColors.shellGreyBody,
                    ),
                  ),
                ),
                if (idx < widget.schema.sections.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: completed ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellBorder,
                  ),
              ],
            );
          }),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              SectionCard(
                title: widget.schema.sections[_currentStep].title,
                description: widget.schema.sections[_currentStep].description,
                child: FormSectionWidget(
                  section: widget.schema.sections[_currentStep],
                  formValues: widget.formValues,
                  onValueChanged: widget.onValueChanged,
                ),
              ),
              WizardNavigationRow(
                currentStep: _currentStep,
                totalSteps: widget.schema.sections.length,
                onPrevious: () => setState(() => _currentStep--),
                onNext: () => setState(() => _currentStep++),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PercentageCompletionForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const PercentageCompletionForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  double get completionPercentage {
    return _completionFraction(schema, formValues);
  }

  @override
  Widget build(BuildContext context) {
    final percent = (completionPercentage * 100).toInt();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdiyogiColors.shellWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdiyogiColors.shellBorder),
          ),
          child: Row(
            children: [
              CircularProgressIndicator(
                value: completionPercentage,
                color: AdiyogiColors.shellCharcoal,
                backgroundColor: AdiyogiColors.surfaceSubtle,
              ),
              const SizedBox(width: 16),
              Text(
                'Form Progress: $percent% Complete',
                style: AdiyogiTextStyles.labelLarge(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class ChecklistCompletionForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ChecklistCompletionForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  bool isSectionFilled(FormSection sec) {
    return _sectionIsComplete(sec, formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdiyogiColors.shellWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdiyogiColors.shellBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Form Requirements Checklist', style: AdiyogiTextStyles.labelMedium(context)),
              const SizedBox(height: 8),
              ...schema.sections.map((sec) {
                final filled = isSectionFilled(sec);
                return Row(
                  children: [
                    Icon(filled ? Icons.check_circle : Icons.circle_outlined,
                        size: 16, color: filled ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody),
                    const SizedBox(width: 8),
                    Text(sec.title, style: AdiyogiTextStyles.bodyMedium(context)),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class QuestionCardForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const QuestionCardForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final allQuestions = _allQuestions(schema);
    return Column(
      children: allQuestions.map((q) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: AdiyogiColors.shellWhite,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AdiyogiColors.shellBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FormQuestionWidget(
              question: q,
              value: formValues[q.id],
              onChanged: (val) => onValueChanged(q.id, val),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SectionCardForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const SectionCardForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: schema.sections.map((sec) {
        return SectionCard(
          title: sec.title,
          description: sec.description,
          child: FormSectionWidget(
            section: sec,
            formValues: formValues,
            onValueChanged: onValueChanged,
          ),
        );
      }).toList(),
    );
  }
}

class KanbanStyleFormSections extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const KanbanStyleFormSections({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final incomplete = <FormSection>[];
    final complete = <FormSection>[];

    for (final sec in schema.sections) {
      if (_sectionIsComplete(sec, formValues)) {
        complete.add(sec);
      } else {
        incomplete.add(sec);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColumn(context, 'Incomplete (${incomplete.length})', incomplete, AdiyogiColors.shellBackground)),
        const SizedBox(width: 12),
        Expanded(child: _buildColumn(context, 'Complete (${complete.length})', complete, AdiyogiColors.shellBackground)),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, String title, List<FormSection> list, Color bg) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AdiyogiTextStyles.labelMedium(context)),
          const SizedBox(height: 8),
          ...list.map(
            (sec) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(sec.title, style: AdiyogiTextStyles.bodyMedium(context)),
                subtitle: Text('${sec.questions.length} fields', style: AdiyogiTextStyles.uiMicro(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ConditionalDynamicForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ConditionalDynamicForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final visibleSections = schema.sections.where((sec) {
      return sec.questions.any((question) {
        final dependencyFieldId = question.dependencyFieldId;
        if (dependencyFieldId == null) return true;
        return formValues[dependencyFieldId] == question.dependencyValue;
      });
    }).toList();
    final visibleQuestions = _allQuestions(
      FormSchema(title: schema.title, description: schema.description, sections: visibleSections),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          color: AdiyogiColors.shellBackground,
          child: Text(
            'Check "I have a government issued ID card" under Documents to reveal sub-questions dynamically.',
            style: AdiyogiTextStyles.uiMicro(context).copyWith(color: AdiyogiColors.shellGreyBody),
          ),
        ),
        if (visibleSections.length != schema.sections.length) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Showing ${visibleSections.length} of ${schema.sections.length} sections and ${visibleQuestions.length} visible questions.',
              style: AdiyogiTextStyles.uiMicro(context),
            ),
          ),
        ],
        ClassicLongForm(
          schema: FormSchema(
            title: schema.title,
            description: schema.description,
            sections: visibleSections,
          ),
          formValues: formValues,
          onValueChanged: onValueChanged,
        ),
      ],
    );
  }
}

class ReviewBeforeSubmitLayout extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ReviewBeforeSubmitLayout({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuestions = _allQuestions(schema).length;
    final completedQuestions = _allQuestions(schema).where((q) {
      final value = formValues[q.id];
      return value != null && value.toString().trim().isNotEmpty;
    }).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review ${schema.sections.length} sections and ${totalQuestions - completedQuestions} unanswered questions before submit.',
          style: AdiyogiTextStyles.uiMicro(context),
        ),
        const SizedBox(height: 12),
        ...schema.sections.map((sec) {
          final sectionComplete = _sectionIsComplete(sec, formValues);
          final filledCount = _filledQuestionCount(sec, formValues);
          return SectionCard(
            title: sec.title,
            description: sectionComplete
                ? 'All required answers captured'
                : '$filledCount of ${sec.questions.length} answers filled',
            child: Column(
              children: [
                if (sectionComplete)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Chip(
                        label: Text('Complete', style: AdiyogiTextStyles.uiMicro(context)),
                        backgroundColor: AdiyogiColors.shellBackground,
                        side: const BorderSide(color: AdiyogiColors.shellBorder),
                      ),
                    ),
                  ),
                ...sec.questions.map((q) {
                  final val = formValues[q.id] ?? '(Not answered)';
                  final answered = val.toString() != '(Not answered)';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(q.label, style: AdiyogiTextStyles.labelLarge(context)),
                    subtitle: Text(
                      answered ? val.toString() : 'Not answered',
                      style: AdiyogiTextStyles.bodyMedium(context),
                    ),
                    trailing: Icon(
                      answered ? Icons.edit : Icons.radio_button_unchecked,
                      size: 16,
                      color: answered ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: AdiyogiColors.shellCharcoal),
          child: const Text('Confirm & Submit'),
        ),
      ],
    );
  }
}

class AccordionMultipleOpenForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const AccordionMultipleOpenForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<AccordionMultipleOpenForm> createState() => _AccordionMultipleOpenFormState();
}

class _AccordionMultipleOpenFormState extends State<AccordionMultipleOpenForm> {
  final Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.schema.sections.map((sec) {
        final open = _expanded[sec.id] ?? true;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            initiallyExpanded: open,
            onExpansionChanged: (val) => setState(() => _expanded[sec.id] = val),
            title: Text(sec.title),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: FormSectionWidget(
                  section: sec,
                  formValues: widget.formValues,
                  onValueChanged: widget.onValueChanged,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class TreeNavigationForm extends StatefulWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const TreeNavigationForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  State<TreeNavigationForm> createState() => _TreeNavigationFormState();
}

class _TreeNavigationFormState extends State<TreeNavigationForm> {
  String? _selectedSecId;

  @override
  void initState() {
    super.initState();
    if (widget.schema.sections.isNotEmpty) {
      _selectedSecId = widget.schema.sections.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.schema.sections.firstWhere((s) => s.id == _selectedSecId, orElse: () => widget.schema.sections.first);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: widget.schema.sections.map((sec) {
              final activeSec = _selectedSecId == sec.id;
              final complete = _sectionIsComplete(sec, widget.formValues);
              return ListTile(
                leading: Icon(activeSec ? Icons.folder_open : Icons.folder),
                title: Text(sec.title, style: TextStyle(fontSize: 12, fontWeight: activeSec ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text(
                  complete ? 'Complete' : '${_filledQuestionCount(sec, widget.formValues)} / ${sec.questions.length}',
                  style: AdiyogiTextStyles.uiMicro(context),
                ),
                trailing: Icon(
                  complete ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 16,
                  color: complete ? AdiyogiColors.shellCharcoal : AdiyogiColors.shellGreyBody,
                ),
                onTap: () => setState(() => _selectedSecId = sec.id),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: SectionCard(
            title: active.title,
            description: active.description,
            child: FormSectionWidget(section: active, formValues: widget.formValues, onValueChanged: widget.onValueChanged),
          ),
        ),
      ],
    );
  }
}

class ProgressBarForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ProgressBarForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  double get completionPercentage {
    return _completionFraction(schema, formValues);
  }

  @override
  Widget build(BuildContext context) {
    final percent = (completionPercentage * 100).toInt();
    return Column(
      children: [
        LinearProgressIndicator(
          value: completionPercentage,
          color: AdiyogiColors.shellCharcoal,
          backgroundColor: AdiyogiColors.surfaceSubtle,
        ),
        const SizedBox(height: 24),
        Text(
          'Form Progress: $percent% Complete',
          style: AdiyogiTextStyles.labelLarge(context),
        ),
        const SizedBox(height: 16),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class StepIndicatorForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const StepIndicatorForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalSteps = schema.sections.isEmpty ? 1 : schema.sections.length;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AdiyogiColors.shellCharcoal,
              child: const Text('1', style: TextStyle(fontSize: 10, color: AdiyogiColors.shellWhite)),
            ),
            const SizedBox(width: 8),
            Text('Step 1 of $totalSteps', style: AdiyogiTextStyles.labelMedium(context)),
          ],
        ),
        const SizedBox(height: 24),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class ConversationalForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ConversationalForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final questions = _allQuestions(schema);
    final activeQuestion = questions.firstWhere(
      (question) {
        final value = formValues[question.id];
        return value == null || value.toString().trim().isEmpty;
      },
      orElse: () => questions.isNotEmpty
          ? questions.last
          : const FormQuestion(id: 'empty', label: 'No questions available', type: QuestionType.text),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conversation mode keeps the same field styling and changes only the interaction flow.',
          style: AdiyogiTextStyles.uiMicro(context),
        ),
        const SizedBox(height: 24),
        if (questions.isNotEmpty) ...[
          SectionCard(
            title: 'Assistant prompt',
            description: 'Current question',
            child: FormQuestionWidget(
              question: activeQuestion,
              value: formValues[activeQuestion.id],
              onChanged: (val) => onValueChanged(activeQuestion.id, val),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class ChatStyleForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ChatStyleForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final questions = _allQuestions(schema);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI Form Assistant', style: AdiyogiTextStyles.labelLarge(context)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AdiyogiColors.shellWhite,
            borderRadius: BorderRadius.circular(8),
            border: const Border.fromBorderSide(BorderSide(color: AdiyogiColors.shellBorder)),
          ),
          child: Text(
            'Hello! Please complete the requested details.',
            style: AdiyogiTextStyles.bodyMedium(context),
          ),
        ),
        if (questions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Recent prompt', style: AdiyogiTextStyles.uiMicro(context)),
          const SizedBox(height: 8),
          FormQuestionWidget(
            question: questions.first,
            value: formValues[questions.first.id],
            onChanged: (val) => onValueChanged(questions.first.id, val),
          ),
        ],
        const SizedBox(height: 24),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
      ],
    );
  }
}

class DrawerForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const DrawerForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeQuestion = _firstUnansweredQuestion(schema, formValues);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Drawer layout', style: AdiyogiTextStyles.labelLarge(context)),
        const SizedBox(height: 4),
        Text(
          'Slides the form into a compact right-aligned workspace while keeping the same styling.',
          style: AdiyogiTextStyles.uiMicro(context),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AdiyogiColors.shellWhite,
                borderRadius: BorderRadius.circular(12),
                border: const Border.fromBorderSide(BorderSide(color: AdiyogiColors.shellBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeQuestion != null) ...[
                    Text('Current focus', style: AdiyogiTextStyles.uiMicro(context)),
                    const SizedBox(height: 8),
                    FormQuestionWidget(
                      question: activeQuestion,
                      value: formValues[activeQuestion.id],
                      onChanged: (val) => onValueChanged(activeQuestion.id, val),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ModalForm extends StatelessWidget {
  final FormSchema schema;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const ModalForm({
    super.key,
    required this.schema,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeQuestion = _firstUnansweredQuestion(schema, formValues);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Material(
          color: AdiyogiColors.shellWhite,
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modal layout', style: AdiyogiTextStyles.sectionHeading(context)),
                  const SizedBox(height: 4),
                  Text(
                    'This keeps the editor chrome unchanged while framing the same content in a modal shell.',
                    style: AdiyogiTextStyles.uiMicro(context),
                  ),
                  const SizedBox(height: 16),
                  if (activeQuestion != null) ...[
                    SectionCard(
                      title: 'Focus question',
                      description: 'Resume where the form is incomplete',
                      child: FormQuestionWidget(
                        question: activeQuestion,
                        value: formValues[activeQuestion.id],
                        onChanged: (val) => onValueChanged(activeQuestion.id, val),
                      ),
                    ),
                  ],
                  ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
