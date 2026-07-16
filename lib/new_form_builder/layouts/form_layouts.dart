import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../widgets/reusable_widgets.dart';

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
            color: AdiyogiColors.pureWhite,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AdiyogiColors.borderLight),
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
            color: AdiyogiColors.pureWhite,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AdiyogiColors.borderLight),
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
          color: AdiyogiColors.charcoal,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormNavigationButton(
              label: 'Previous',
              primary: false,
              onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
            ),
            FormNavigationButton(
              label: _currentStep < widget.schema.sections.length - 1 ? 'Next' : 'Submit',
              onPressed: _currentStep < widget.schema.sections.length - 1 ? () => setState(() => _currentStep++) : null,
            ),
          ],
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
          color: AdiyogiColors.charcoal,
          backgroundColor: AdiyogiColors.surfaceSubtle,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AdiyogiColors.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AdiyogiColors.borderLight),
          ),
          child: FormQuestionWidget(
            question: question,
            value: widget.formValues[question.id],
            onChanged: (val) => widget.onValueChanged(question.id, val),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormNavigationButton(
              label: 'Back',
              primary: false,
              onPressed: _currentQuestionIndex > 0 ? () => setState(() => _currentQuestionIndex--) : null,
            ),
            FormNavigationButton(
              label: _currentQuestionIndex < questions.length - 1 ? 'Continue' : 'Submit',
              onPressed: _currentQuestionIndex < questions.length - 1
                  ? () => setState(() => _currentQuestionIndex++)
                  : null,
            ),
          ],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormNavigationButton(
              label: 'Back',
              primary: false,
              onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
            ),
            FormNavigationButton(
              label: _currentStep < stepCount - 1 ? 'Next Step' : 'Finish',
              onPressed: _currentStep < stepCount - 1 ? () => setState(() => _currentStep++) : null,
            ),
          ],
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
          border: Border.all(color: AdiyogiColors.borderLight, width: 4),
          borderRadius: BorderRadius.circular(32),
          color: AdiyogiColors.surfaceWhite,
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
                      backgroundColor: AdiyogiColors.charcoal,
                      foregroundColor: AdiyogiColors.pureWhite,
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
                    color: _currentPage == index ? AdiyogiColors.charcoal : AdiyogiColors.borderLight,
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
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: AdiyogiColors.borderLight)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.schema.sections.length, (idx) {
              final active = _selectedIndex == idx;
              return TextButton(
                onPressed: () => setState(() => _selectedIndex = idx),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: active ? AdiyogiColors.charcoal : AdiyogiColors.greyBody,
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
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AdiyogiColors.borderLight)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.schema.sections.length, (idx) {
              final active = _selectedIndex == idx;
              return TextButton(
                onPressed: () => setState(() => _selectedIndex = idx),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: active ? AdiyogiColors.charcoal : AdiyogiColors.greyBody,
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
                        color: active ? AdiyogiColors.charcoal : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.schema.sections[idx].title,
                    style: TextStyle(
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? AdiyogiColors.charcoal : AdiyogiColors.greyMuted,
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
          labelColor: AdiyogiColors.charcoal,
          unselectedLabelColor: AdiyogiColors.greyMuted,
          indicatorColor: AdiyogiColors.charcoal,
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
            const Text('Form', style: TextStyle(color: AdiyogiColors.greyMuted)),
            const Icon(Icons.chevron_right, size: 16, color: AdiyogiColors.greyMuted),
            Text(active.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AdiyogiColors.charcoal)),
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
                      ? AdiyogiColors.charcoal
                      : (completed ? AdiyogiColors.borderLight : AdiyogiColors.surfaceSubtle),
                  child: Text(
                    '${idx + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: activeStep || completed ? AdiyogiColors.pureWhite : AdiyogiColors.greyMuted,
                    ),
                  ),
                ),
                if (idx < widget.schema.sections.length - 1)
                  Container(
                    width: 30,
                    height: 2,
                    color: completed ? AdiyogiColors.charcoal : AdiyogiColors.borderLight,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FormNavigationButton(
              label: 'Previous',
              primary: false,
              onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
            ),
            FormNavigationButton(
              label: _currentStep < widget.schema.sections.length - 1 ? 'Next' : 'Submit',
              onPressed: _currentStep < widget.schema.sections.length - 1 ? () => setState(() => _currentStep++) : null,
            ),
          ],
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
                      ? AdiyogiColors.charcoal
                      : (completed ? AdiyogiColors.borderLight : AdiyogiColors.surfaceSubtle),
                  child: Text(
                    '${idx + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: activeStep || completed ? AdiyogiColors.pureWhite : AdiyogiColors.greyMuted,
                    ),
                  ),
                ),
                if (idx < widget.schema.sections.length - 1)
                  Container(
                    width: 2,
                    height: 50,
                    color: completed ? AdiyogiColors.charcoal : AdiyogiColors.borderLight,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormNavigationButton(
                    label: 'Previous',
                    primary: false,
                    onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
                  ),
                  FormNavigationButton(
                    label: _currentStep < widget.schema.sections.length - 1 ? 'Next' : 'Submit',
                    onPressed: _currentStep < widget.schema.sections.length - 1 ? () => setState(() => _currentStep++) : null,
                  ),
                ],
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
    final allQuestions = schema.sections.expand((sec) => sec.questions).toList();
    if (allQuestions.isEmpty) return 0;
    int filled = 0;
    for (var q in allQuestions) {
      if (formValues[q.id] != null && formValues[q.id].toString().isNotEmpty) {
        filled++;
      }
    }
    return filled / allQuestions.length;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (completionPercentage * 100).toInt();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdiyogiColors.pureWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdiyogiColors.borderLight),
          ),
          child: Row(
            children: [
              CircularProgressIndicator(
                value: completionPercentage,
                color: AdiyogiColors.charcoal,
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
    for (var q in sec.questions) {
      if (q.required) {
        final val = formValues[q.id];
        if (val == null || val.toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AdiyogiColors.pureWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AdiyogiColors.borderLight),
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
                        size: 16, color: filled ? Colors.green : AdiyogiColors.greyMuted),
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
    final allQuestions = schema.sections.expand((sec) => sec.questions).toList();
    return Column(
      children: allQuestions.map((q) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: AdiyogiColors.pureWhite,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AdiyogiColors.borderLight),
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

class KanbanStyleFormSections extends StatefulWidget {
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
  State<KanbanStyleFormSections> createState() => _KanbanStyleFormSectionsState();
}

class _KanbanStyleFormSectionsState extends State<KanbanStyleFormSections> {
  bool isSectionFilled(FormSection sec) {
    for (var q in sec.questions) {
      if (q.required) {
        final val = widget.formValues[q.id];
        if (val == null || val.toString().isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final incomplete = <FormSection>[];
    final complete = <FormSection>[];

    for (var sec in widget.schema.sections) {
      if (isSectionFilled(sec)) {
        complete.add(sec);
      } else {
        incomplete.add(sec);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColumn('Incomplete (${incomplete.length})', incomplete, Colors.grey.shade100)),
        const SizedBox(width: 12),
        Expanded(child: _buildColumn('Complete (${complete.length})', complete, Colors.green.shade50)),
      ],
    );
  }

  Widget _buildColumn(String title, List<FormSection> list, Color bg) {
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
          ...list.map((sec) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(sec.title, style: AdiyogiTextStyles.bodyMedium(context)),
                  subtitle: Text('${sec.questions.length} fields', style: AdiyogiTextStyles.uiMicro(context)),
                ),
              )),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.amber.shade50,
          child: Text(
            'Check "I have a government issued ID card" under Documents to reveal sub-questions dynamically.',
            style: AdiyogiTextStyles.uiMicro(context).copyWith(color: Colors.amber.shade900),
          ),
        ),
        ClassicLongForm(schema: schema, formValues: formValues, onValueChanged: onValueChanged),
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
    return Column(
      children: [
        ...schema.sections.map((sec) {
          return SectionCard(
            title: sec.title,
            description: 'Summary of answers',
            child: Column(
              children: sec.questions.map((q) {
                final val = formValues[q.id] ?? '(Not answered)';
                return ListTile(
                  title: Text(q.label),
                  subtitle: Text(val.toString()),
                  trailing: const Icon(Icons.edit, size: 16),
                );
              }).toList(),
            ),
          );
        }),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: AdiyogiColors.charcoal),
          child: const Text('Confirm & Submit'),
        ),
      ],
    );
  }
}
