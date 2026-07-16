// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/form_schema.dart';

class FormThemeState {
  static Color primary = const Color(0xFF1B1B21);
  static Color background = const Color(0xFFF7F7F8);
  static Color cardColor = const Color(0xFFFFFFFF);
  static Color textColor = const Color(0xFF121218);
  static Color borderLight = const Color(0xFFC9CDD2);
  static String fontFamily = 'Instrument Sans';
  static double borderRadius = 16.0;
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
  static Color get pureWhite => FormThemeState.cardColor;
  static Color get surfaceSubtle => const Color(0xFFEDEEF1);
  static Color get surfaceWhite => FormThemeState.background;
  static Color get charcoal => FormThemeState.primary;
  static Color get greyBody => FormThemeState.textColor.withOpacity(0.7);
  static Color get greyMuted => FormThemeState.textColor.withOpacity(0.5);
  static Color get inkBlack => FormThemeState.textColor;
  static Color get slateMid => FormThemeState.textColor.withOpacity(0.85);
  static Color get borderLight => FormThemeState.borderLight;
}

// --- Typography Helpers ---
class AdiyogiTextStyles {
  static TextStyle displayHeading(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 36, // Scaled for app usage
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AdiyogiColors.inkBlack,
      );

  static TextStyle sectionHeading(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AdiyogiColors.inkBlack,
      );

  static TextStyle cardHeading(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AdiyogiColors.inkBlack,
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AdiyogiColors.greyBody,
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: AdiyogiColors.greyBody,
      );

  static TextStyle labelLarge(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AdiyogiColors.inkBlack,
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AdiyogiColors.inkBlack,
      );

  static TextStyle uiMicro(BuildContext context) => TextStyle(
        fontFamily: FormThemeState.fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AdiyogiColors.greyMuted,
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
        color: AdiyogiColors.pureWhite,
        borderRadius: BorderRadius.circular(FormThemeState.borderRadius),
        border: Border.all(color: AdiyogiColors.borderLight, width: 1),
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
                Container(
                  width: 160,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AdiyogiColors.greyBody.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 240,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AdiyogiColors.greyMuted.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
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
        Container(
          width: 100,
          height: 12,
          decoration: BoxDecoration(
            color: AdiyogiColors.inkBlack.withOpacity(0.15),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
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
            color: AdiyogiColors.surfaceWhite,
            borderRadius: BorderRadius.circular(FormThemeState.borderRadius / 2),
            border: Border.all(color: AdiyogiColors.borderLight),
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
            color: AdiyogiColors.surfaceWhite,
            borderRadius: BorderRadius.circular(FormThemeState.borderRadius / 2),
            border: Border.all(color: AdiyogiColors.borderLight),
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
              suffixIcon: Icon(Icons.calendar_month, color: AdiyogiColors.greyMuted),
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
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdiyogiColors.surfaceWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AdiyogiColors.borderLight),
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
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AdiyogiColors.surfaceWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AdiyogiColors.borderLight),
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
          Icon(Icons.keyboard_arrow_down, size: 16, color: AdiyogiColors.greyMuted),
        ],
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
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: AdiyogiColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AdiyogiColors.borderLight),
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
                  border: Border.all(color: AdiyogiColors.borderLight),
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
          backgroundColor: AdiyogiColors.charcoal,
          foregroundColor: AdiyogiColors.pureWhite,
          shadowColor: AdiyogiColors.greyMuted.withOpacity(0.3),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: AdiyogiColors.pureWhite),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AdiyogiColors.charcoal,
          side: BorderSide(color: AdiyogiColors.borderLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: AdiyogiColors.charcoal),
        ),
      );
    }
  }
}
