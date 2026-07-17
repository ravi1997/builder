// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../providers/form_builder_provider.dart';
import '../models/form_theme_config.dart';

extension FormThemeContextX on BuildContext {
  FormThemeConfig get themeConfig => FormThemeScope.of(this)?.themeConfig ?? const FormThemeConfig();
  bool get skeletonMode => FormThemeScope.of(this)?.skeletonMode ?? true;
}

// --- Colors ---
class AdiyogiColors {
  // Static shell colors (unchangeable, keeps the editor UI consistent)
  static const Color shellWhite = Color(0xFFFFFFFF);
  static const Color shellBackground = Color(0xFFF7F7F8);
  static const Color shellCharcoal = Color(0xFF1B1B21);
  static const Color shellGreyBody = Color(0xFF44454C);
  static const Color shellGreyMuted = Color(0xFF9E9E9E);
  static const Color shellBorder = Color(0xFFE5E7EB);

  // Dynamic preview colors (binds to current theme state)
  static Color pureWhite(BuildContext context) => context.themeConfig.cardColor;
  static const Color surfaceSubtle = Color(0xFFEDEEF1);
  static Color surfaceWhite(BuildContext context) => context.themeConfig.background;
  static Color charcoal(BuildContext context) => context.themeConfig.primary;
  static Color greyBody(BuildContext context) => context.themeConfig.textColor.withValues(alpha: 0.7);
  static Color greyMuted(BuildContext context) => context.themeConfig.textColor.withValues(alpha: 0.5);
  static Color inkBlack(BuildContext context) => context.themeConfig.textColor;
  static Color slateMid(BuildContext context) => context.themeConfig.textColor.withValues(alpha: 0.85);
  static Color borderLight(BuildContext context) => context.themeConfig.inputColor;
}

// --- Typography Helpers ---
class AdiyogiTextStyles {
  static TextStyle displayHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.titleSize,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AdiyogiColors.inkBlack(context),
      );

  static TextStyle sectionHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.sectionSize,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AdiyogiColors.inkBlack(context),
      );

  static TextStyle cardHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.sectionSize + 2,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AdiyogiColors.inkBlack(context),
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize + 2,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AdiyogiColors.greyBody(context),
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AdiyogiColors.greyBody(context),
      );

  static TextStyle labelLarge(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AdiyogiColors.inkBlack(context),
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AdiyogiColors.inkBlack(context),
      );

  static TextStyle uiMicro(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AdiyogiColors.greyMuted(context),
      );
}

// --- Reusable Components ---

class SectionCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AdiyogiColors.pureWhite(context),
        borderRadius: BorderRadius.circular(context.themeConfig.borderRadius),
        border: Border.all(color: AdiyogiColors.borderLight(context), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A121218),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AdiyogiColors.surfaceSubtle, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (context.skeletonMode) ...[
                  Container(
                    width: 160,
                    height: context.themeConfig.sectionSize - 2,
                    decoration: BoxDecoration(
                      color: AdiyogiColors.greyBody(context).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 240,
                    height: context.themeConfig.questionSize - 4,
                    decoration: BoxDecoration(
                      color: AdiyogiColors.greyMuted(context).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ] else ...[
                  Text(title, style: AdiyogiTextStyles.sectionHeading(context)),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(description, style: AdiyogiTextStyles.bodyMedium(context)),
                  ],
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

class FormSectionWidget extends StatelessWidget {
  final FormSection section;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;

  const FormSectionWidget({
    super.key,
    required this.section,
    required this.formValues,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: section.questions.map((question) {
        // Handle dependencies
        if (question.dependencyFieldId != null) {
          final depValue = formValues[question.dependencyFieldId];
          if (depValue != question.dependencyValue) {
            return const SizedBox.shrink();
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FormQuestionWidget(
            question: question,
            value: formValues[question.id],
            onChanged: (val) => onValueChanged(question.id, val),
          ),
        );
      }).toList(),
    );
  }
}

class FormQuestionWidget extends StatelessWidget {
  final FormQuestion question;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const FormQuestionWidget({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (context.skeletonMode)
          Container(
            width: 100,
            height: context.themeConfig.questionSize - 2,
            decoration: BoxDecoration(
              color: AdiyogiColors.inkBlack(context).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
            ),
          )
        else
          Text(question.label, style: AdiyogiTextStyles.labelMedium(context)),
        const SizedBox(height: 12),
        _buildInputField(context),
      ],
    );
  }

  Widget _buildInputField(BuildContext context) {
    switch (question.type) {
      case QuestionType.text:
        return TextInputField(
          placeholder: question.placeholder,
          value: value as String? ?? '',
          onChanged: onChanged,
        );
      case QuestionType.email:
        return TextInputField(
          placeholder: question.placeholder ?? 'email@domain.com',
          value: value as String? ?? '',
          onChanged: onChanged,
          suffixIcon: const Icon(Icons.email, size: 16, color: Colors.grey),
        );
      case QuestionType.number:
        return TextInputField(
          placeholder: question.placeholder ?? '0',
          value: value as String? ?? '',
          onChanged: onChanged,
          suffixIcon: const Icon(Icons.numbers, size: 16, color: Colors.grey),
        );
      case QuestionType.dropdown:
        return DropdownField(
          options: question.options ?? [],
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionType.checkbox:
        return CheckboxField(
          label: question.label,
          value: value as bool? ?? false,
          onChanged: onChanged,
        );
      case QuestionType.radio:
        return RadioField(
          options: question.options ?? [],
          value: value as String?,
          onChanged: onChanged,
        );
      case QuestionType.fileUpload:
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: AdiyogiColors.surfaceWhite(context),
            borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
            border: Border.all(color: AdiyogiColors.borderLight(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.cloud_upload, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Upload File (PDF, PNG, JPG)', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      case QuestionType.longText:
        return Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AdiyogiColors.surfaceWhite(context),
            borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
            border: Border.all(color: AdiyogiColors.borderLight(context)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Type long message...', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        );
      case QuestionType.date:
        return GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onChanged('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
            }
          },
          child: AbsorbPointer(
            child: TextInputField(
              placeholder: question.placeholder ?? 'YYYY-MM-DD',
              value: value as String? ?? '',
              onChanged: onChanged,
              suffixIcon: Icon(Icons.calendar_month, color: AdiyogiColors.greyMuted(context)),
            ),
          ),
        );
    }
  }
}

class TextInputField extends StatelessWidget {
  final String? placeholder;
  final String value;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;

  const TextInputField({
    super.key,
    this.placeholder,
    required this.value,
    required this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final suffix = suffixIcon;
    if (context.skeletonMode) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AdiyogiColors.surfaceWhite(context),
          borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
          border: Border.all(color: AdiyogiColors.borderLight(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 12,
        decoration: BoxDecoration(
          color: AdiyogiColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(6),
        ),
            ),
            // ignore: use_null_aware_elements
            if (suffix != null) suffix,
          ],
        ),
      );
    }

    return TextField(
      onChanged: onChanged,
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      decoration: InputDecoration(
        hintText: placeholder ?? 'Enter text...',
        hintStyle: AdiyogiTextStyles.bodyMedium(context).copyWith(color: AdiyogiColors.greyMuted(context)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: AdiyogiColors.surfaceWhite(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
          borderSide: BorderSide(color: AdiyogiColors.borderLight(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
          borderSide: BorderSide(color: AdiyogiColors.borderLight(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
          borderSide: BorderSide(color: AdiyogiColors.charcoal(context), width: 1.5),
        ),
        suffixIcon: suffix,
      ),
      style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: AdiyogiColors.inkBlack(context)),
    );
  }
}

class DropdownField extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (context.skeletonMode) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AdiyogiColors.surfaceWhite(context),
          borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
          border: Border.all(color: AdiyogiColors.borderLight(context)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80,
              height: 12,
              decoration: BoxDecoration(
                color: AdiyogiColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 16, color: AdiyogiColors.greyMuted(context)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdiyogiColors.surfaceWhite(context),
        borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
        border: Border.all(color: AdiyogiColors.borderLight(context)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value != null && options.contains(value) ? value : null,
          isExpanded: true,
          style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: AdiyogiColors.inkBlack(context)),
          onChanged: onChanged,
          items: options.map((opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: Text(opt),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckboxField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (context.skeletonMode) {
      return Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AdiyogiColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AdiyogiColors.borderLight(context)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 150,
            height: 12,
            decoration: BoxDecoration(
              color: AdiyogiColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: AdiyogiColors.charcoal(context),
            onChanged: onChanged,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(label, style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: AdiyogiColors.inkBlack(context))),
          ),
        ],
      ),
    );
  }
}

class RadioField extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const RadioField({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (context.skeletonMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((opt) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AdiyogiColors.surfaceSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(color: AdiyogiColors.borderLight(context)),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AdiyogiColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((opt) {
        return InkWell(
          onTap: () => onChanged(opt),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Radio<String>(
                  value: opt,
                  groupValue: value,
                  activeColor: AdiyogiColors.charcoal(context),
                  onChanged: onChanged,
                ),
                const SizedBox(width: 4),
                Text(opt, style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: AdiyogiColors.inkBlack(context))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class WizardNavigationRow extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String nextLabel;

  const WizardNavigationRow({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
    this.nextLabel = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FormNavigationButton(
          label: 'Previous',
          primary: false,
          onPressed: currentStep > 0 ? onPrevious : null,
        ),
        FormNavigationButton(
          label: currentStep < totalSteps - 1 ? nextLabel : 'Submit',
          onPressed: currentStep < totalSteps - 1 ? onNext : null,
        ),
      ],
    );
  }
}

class FormNavigationButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  const FormNavigationButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (primary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AdiyogiColors.charcoal(context),
          foregroundColor: AdiyogiColors.pureWhite(context),
          shadowColor: AdiyogiColors.greyMuted(context).withOpacity(0.3),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: AdiyogiColors.pureWhite(context)),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AdiyogiColors.charcoal(context),
          side: BorderSide(color: AdiyogiColors.borderLight(context)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: AdiyogiColors.charcoal(context)),
        ),
      );
    }
  }
}
