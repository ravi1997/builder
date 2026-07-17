// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/form_schema.dart';
import '../models/animation_config.dart';
import '../models/component_style_config.dart';
import '../providers/form_builder_provider.dart';
import '../models/form_theme_config.dart';

extension FormThemeContextX on BuildContext {
  FormThemeConfig get themeConfig => FormThemeScope.of(this)?.themeConfig ?? const FormThemeConfig();
  ComponentStyleConfig get componentConfig => FormThemeScope.of(this)?.componentConfig ?? const ComponentStyleConfig();
  AnimationConfig get animConfig => FormThemeScope.of(this)?.animConfig ?? const AnimationConfig();
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

  static const Color surfaceSubtle = Color(0xFFEDEEF1);
}

double formMaxWidthForPreset(FormWidthPreset preset, double fallback) {
  switch (preset) {
    case FormWidthPreset.compact:
      return 560;
    case FormWidthPreset.medium:
      return 760;
    case FormWidthPreset.wide:
      return 1040;
    case FormWidthPreset.full:
      return fallback;
  }
}

BoxDecoration buildBackgroundDecoration(FormThemeConfig theme) {
  switch (theme.backgroundPreset) {
    case BackgroundPreset.solid:
      return BoxDecoration(color: theme.background);
    case BackgroundPreset.subtleGradient:
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.background, theme.background.withValues(alpha: 0.8)],
        ),
      );
    case BackgroundPreset.mesh:
      return BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: [theme.primary.withValues(alpha: 0.12), theme.background],
        ),
      );
    case BackgroundPreset.glass:
      return BoxDecoration(
        color: theme.background.withValues(alpha: 0.82),
      );
    case BackgroundPreset.patternDots:
    case BackgroundPreset.patternGrid:
    case BackgroundPreset.imageLike:
      return BoxDecoration(color: theme.background);
  }
}

Decoration? buildBackgroundPattern(FormThemeConfig theme) {
  switch (theme.backgroundPreset) {
    case BackgroundPreset.patternDots:
      return BoxDecoration(
        gradient: RadialGradient(
          radius: 0.9,
          colors: [
            theme.primary.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          stops: const [0.05, 1],
        ),
      );
    case BackgroundPreset.patternGrid:
      return BoxDecoration(
        border: Border.all(color: theme.primary.withValues(alpha: 0.06), width: 0.5),
      );
    case BackgroundPreset.imageLike:
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.primary.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      );
    case BackgroundPreset.solid:
    case BackgroundPreset.subtleGradient:
    case BackgroundPreset.mesh:
    case BackgroundPreset.glass:
      return null;
  }
}

// --- Typography Helpers ---
class AdiyogiTextStyles {
  static TextStyle displayHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.titleSize,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: context.themeConfig.textColor,
      );

  static TextStyle sectionHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.sectionSize,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: context.themeConfig.textColor,
      );

  static TextStyle cardHeading(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.sectionSize + 2,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: context.themeConfig.textColor,
      );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize + 2,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: context.themeConfig.textColor.withValues(alpha: 0.7),
      );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: context.themeConfig.textColor.withValues(alpha: 0.7),
      );

  static TextStyle labelLarge(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: context.themeConfig.textColor,
      );

  static TextStyle labelMedium(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: context.themeConfig.questionSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: context.themeConfig.textColor,
      );

  static TextStyle uiMicro(BuildContext context) => TextStyle(
        fontFamily: context.themeConfig.fontFamily.toString().split('.').last,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: context.themeConfig.textColor.withValues(alpha: 0.5),
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
    final theme = context.themeConfig;
    final component = context.componentConfig;
    final anim = context.animConfig;
    final borderRadius = _radiusForCard(component.cardStyle, theme.borderRadius);
    final border = _borderForCard(component.cardStyle, component.borderStyle, theme.inputColor);
    final shadow = _shadowForCard(component.shadowLevel);
    final fillColor = _cardFillColor(component.cardStyle, theme.cardColor);
    return Container(
      margin: EdgeInsets.only(bottom: theme.sectionSpacing),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: shadow,
      ),
      child: AnimatedSwitcher(
        duration: anim.duration,
        switchInCurve: anim.curveWidget,
        switchOutCurve: anim.curveWidget.flipped,
        transitionBuilder: (widget, animation) {
          switch (anim.sectionAnim) {
            case SectionAnimationPreset.fadeIn:
              return FadeTransition(opacity: animation, child: widget);
            case SectionAnimationPreset.slideUp:
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation),
                child: widget,
              );
            case SectionAnimationPreset.expand:
              return SizeTransition(sizeFactor: animation, axisAlignment: -1, child: widget);
            case SectionAnimationPreset.bounce:
              return ScaleTransition(scale: animation, child: widget);
          }
        },
        child: Column(
          key: ValueKey<String>('${title}_${description}_${context.skeletonMode}_${component.cardStyle}_${anim.sectionAnim}'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(theme.formPadding * 0.75),
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
                        color: AdiyogiColors.shellGreyBody.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 240,
                      height: context.themeConfig.questionSize - 4,
                      decoration: BoxDecoration(
                        color: AdiyogiColors.shellGreyBody.withValues(alpha: 0.15),
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
              padding: EdgeInsets.all(theme.formPadding * 0.75),
              child: child,
            ),
          ],
        ),
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
    final anim = context.animConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < section.questions.length; index++)
          _AnimatedQuestionRow(
            index: index,
            question: section.questions[index],
            formValues: formValues,
            onValueChanged: onValueChanged,
            anim: anim,
          ),
      ],
    );
  }
}

class _AnimatedQuestionRow extends StatelessWidget {
  final int index;
  final FormQuestion question;
  final Map<String, dynamic> formValues;
  final Function(String, dynamic) onValueChanged;
  final AnimationConfig anim;

  const _AnimatedQuestionRow({
    required this.index,
    required this.question,
    required this.formValues,
    required this.onValueChanged,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    if (question.dependencyFieldId != null) {
      final depValue = formValues[question.dependencyFieldId];
      if (depValue != question.dependencyValue) {
        return const SizedBox.shrink();
      }
    }

    final delay = Duration(milliseconds: index * 35);
    final body = Padding(
      padding: EdgeInsets.only(bottom: context.themeConfig.questionSpacing),
      child: FormQuestionWidget(
        question: question,
        value: formValues[question.id],
        onChanged: (val) => onValueChanged(question.id, val),
      ),
    );

    final animated = switch (anim.inputAnim) {
      InputAnimationPreset.none => body,
      InputAnimationPreset.focusGlow => AnimatedOpacity(
          opacity: 1,
          duration: anim.duration + delay,
          curve: anim.curveWidget,
          child: body,
        ),
      InputAnimationPreset.borderAnim => AnimatedPadding(
          duration: anim.duration + delay,
          curve: anim.curveWidget,
          padding: const EdgeInsets.only(top: 2),
          child: body,
        ),
      InputAnimationPreset.floatingLabel => AnimatedSlide(
          duration: anim.duration + delay,
          curve: anim.curveWidget,
          offset: Offset.zero,
          child: body,
        ),
    };

    return animated;
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
              color: context.themeConfig.textColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
            ),
          )
        else
          Text(question.label, style: AdiyogiTextStyles.labelMedium(context)),
        SizedBox(height: context.themeConfig.questionSpacing / 1.5),
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
          padding: EdgeInsets.symmetric(horizontal: context.themeConfig.inputPadding),
          decoration: BoxDecoration(
            color: context.themeConfig.background,
            borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
            border: Border.all(color: context.themeConfig.inputColor),
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
          padding: EdgeInsets.all(context.themeConfig.inputPadding),
          decoration: BoxDecoration(
            color: context.themeConfig.background,
            borderRadius: BorderRadius.circular(context.themeConfig.borderRadius / 2),
            border: Border.all(color: context.themeConfig.inputColor),
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
              suffixIcon: Icon(Icons.calendar_month, color: context.themeConfig.textColor.withValues(alpha: 0.5)),
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
    final theme = context.themeConfig;
    final component = context.componentConfig;
    final suffix = suffixIcon;
    final borderRadius = _radiusForInput(component.inputStyle, theme.borderRadius);
    final inputBorder = _outlineBorderForInput(component.inputStyle, component.borderStyle, theme.inputColor);
    final inputBoxBorder = _boxBorderForInput(component.inputStyle, component.borderStyle, theme.inputColor);
    final fillColor = _inputFillColor(component.inputStyle, theme.background, theme.cardColor);
    final contentPadding = _paddingForInput(
      component.inputStyle,
      EdgeInsets.symmetric(horizontal: theme.inputPadding, vertical: theme.inputPadding * 0.85),
    );
    if (context.skeletonMode) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: inputBoxBorder,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: component.inputStyle == InputStylePreset.underline ? 160 : 120,
              height: component.inputStyle == InputStylePreset.underline ? 2 : 12,
              decoration: BoxDecoration(
                color: AdiyogiColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(component.inputStyle == InputStylePreset.underline ? 1 : 6),
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
        hintStyle: AdiyogiTextStyles.bodyMedium(context).copyWith(color: context.themeConfig.textColor.withValues(alpha: 0.5)),
        contentPadding: contentPadding,
        filled: true,
        fillColor: fillColor,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(borderSide: const BorderSide(color: AdiyogiColors.shellCharcoal, width: 1.5)),
        errorBorder: inputBorder.copyWith(borderSide: const BorderSide(color: AdiyogiColors.shellGreyBody, width: 1.5)),
        focusedErrorBorder: inputBorder.copyWith(borderSide: const BorderSide(color: AdiyogiColors.shellGreyBody, width: 1.5)),
        suffixIcon: suffix,
        hoverColor: AdiyogiColors.shellGreyBody.withValues(alpha: 0.04),
        floatingLabelBehavior: component.inputStyle == InputStylePreset.floatingLabel
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
      ),
      style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: context.themeConfig.textColor),
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
    final theme = context.themeConfig;
    final component = context.componentConfig;
    final borderRadius = _radiusForInput(component.inputStyle, theme.borderRadius);
    final inputBoxBorder = _boxBorderForInput(component.inputStyle, component.borderStyle, theme.inputColor);
    final fillColor = _inputFillColor(component.inputStyle, theme.background, theme.cardColor);
    if (context.skeletonMode) {
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: inputBoxBorder,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: component.inputStyle == InputStylePreset.underline ? 120 : 80,
              height: component.inputStyle == InputStylePreset.underline ? 2 : 12,
              decoration: BoxDecoration(
                color: AdiyogiColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(component.inputStyle == InputStylePreset.underline ? 1 : 6),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: AdiyogiColors.shellGreyBody),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.inputPadding),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: inputBoxBorder,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value != null && options.contains(value) ? value : null,
          isExpanded: true,
          style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: context.themeConfig.textColor),
          onChanged: onChanged,
          dropdownColor: AdiyogiColors.shellWhite,
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
    final component = context.componentConfig;
    if (context.skeletonMode) {
      return Row(
        children: [
          Container(
            width: 18,
            height: 18,
              decoration: BoxDecoration(
                color: AdiyogiColors.surfaceSubtle,
                shape: component.inputStyle == InputStylePreset.rounded ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: component.inputStyle == InputStylePreset.rounded ? null : BorderRadius.circular(4),
                border: const Border.fromBorderSide(BorderSide(color: AdiyogiColors.shellBorder)),
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
            activeColor: AdiyogiColors.shellCharcoal,
            onChanged: onChanged,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(label, style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: context.themeConfig.textColor)),
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
                    border: const Border.fromBorderSide(BorderSide(color: AdiyogiColors.shellBorder)),
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
                  activeColor: AdiyogiColors.shellCharcoal,
                  onChanged: onChanged,
                ),
                const SizedBox(width: 4),
                Text(opt, style: AdiyogiTextStyles.bodyMedium(context).copyWith(color: context.themeConfig.textColor)),
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
    final theme = context.themeConfig;
    final component = context.componentConfig;
    final borderRadius = _radiusForButton(component.buttonStyle, theme.borderRadius);
    final border = _borderForButton(component.buttonStyle, component.borderStyle);
    final backgroundColor = _buttonBackground(component.buttonStyle);
    final foregroundColor = _buttonForeground(component.buttonStyle);
    if (primary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shadowColor: context.themeConfig.textColor.withValues(alpha: 0.5),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          overlayColor: component.buttonStyle == ButtonStylePreset.glass ? AdiyogiColors.shellGreyBody.withValues(alpha: 0.08) : null,
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: foregroundColor),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: border,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: AdiyogiTextStyles.labelMedium(context).copyWith(color: context.themeConfig.primary),
        ),
      );
    }
  }
}

double _radiusForCard(CardStylePreset style, double themeRadius) {
  switch (style) {
    case CardStylePreset.flat:
      return 0;
    case CardStylePreset.border:
      return themeRadius;
    case CardStylePreset.shadow:
      return themeRadius + 2;
    case CardStylePreset.floating:
      return themeRadius + 6;
    case CardStylePreset.glass:
      return themeRadius + 10;
  }
}

double _radiusForInput(InputStylePreset style, double themeRadius) {
  switch (style) {
    case InputStylePreset.underline:
      return 0;
    case InputStylePreset.rounded:
      return themeRadius / 2;
    case InputStylePreset.floatingLabel:
      return themeRadius / 2;
    case InputStylePreset.filled:
      return themeRadius / 3;
    case InputStylePreset.outlined:
      return themeRadius / 2;
  }
}

double _radiusForButton(ButtonStylePreset style, double themeRadius) {
  switch (style) {
    case ButtonStylePreset.text:
      return 0;
    case ButtonStylePreset.outlined:
      return themeRadius / 2;
    case ButtonStylePreset.filled:
      return themeRadius / 2;
    case ButtonStylePreset.gradient:
      return themeRadius;
    case ButtonStylePreset.glass:
      return themeRadius;
  }
}

Border? _borderForCard(CardStylePreset cardStyle, BorderStylePreset borderStyle, Color borderColor) {
  if (cardStyle == CardStylePreset.flat) return null;
  final width = _borderWidth(borderStyle);
  if (width == 0) return null;
  return Border.all(color: borderColor, width: width);
}

OutlineInputBorder _outlineBorderForInput(InputStylePreset inputStyle, BorderStylePreset borderStyle, Color borderColor) {
  final width = _borderWidth(borderStyle);
  final sideColor = width == 0 ? Colors.transparent : borderColor;
  switch (inputStyle) {
    case InputStylePreset.underline:
      return OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: sideColor, width: width == 0 ? 1 : width),
      );
    case InputStylePreset.filled:
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: sideColor, width: width == 0 ? 1 : width),
      );
    case InputStylePreset.floatingLabel:
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: sideColor, width: width == 0 ? 1 : width),
      );
    case InputStylePreset.rounded:
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: sideColor, width: width == 0 ? 1 : width),
      );
    case InputStylePreset.outlined:
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: sideColor, width: width == 0 ? 1 : width),
      );
  }
}

BoxBorder _boxBorderForInput(InputStylePreset inputStyle, BorderStylePreset borderStyle, Color borderColor) {
  final width = _borderWidth(borderStyle);
  final sideColor = width == 0 ? Colors.transparent : borderColor;
  switch (inputStyle) {
    case InputStylePreset.underline:
      return Border(bottom: BorderSide(color: sideColor, width: width == 0 ? 1 : width));
    case InputStylePreset.filled:
    case InputStylePreset.floatingLabel:
    case InputStylePreset.rounded:
    case InputStylePreset.outlined:
      return Border.all(color: sideColor, width: width == 0 ? 1 : width);
  }
}

BorderSide _borderForButton(ButtonStylePreset style, BorderStylePreset borderStyle) {
  if (style == ButtonStylePreset.text) {
    return BorderSide.none;
  }
  final width = _borderWidth(borderStyle);
  return BorderSide(color: AdiyogiColors.shellBorder, width: width == 0 ? 1 : width);
}

Color _cardFillColor(CardStylePreset style, Color cardColor) {
  switch (style) {
    case CardStylePreset.flat:
      return Colors.transparent;
    case CardStylePreset.border:
    case CardStylePreset.shadow:
      return cardColor;
    case CardStylePreset.floating:
      return cardColor;
    case CardStylePreset.glass:
      return cardColor.withValues(alpha: 0.7);
  }
}

Color _buttonBackground(ButtonStylePreset style) {
  switch (style) {
    case ButtonStylePreset.outlined:
    case ButtonStylePreset.text:
      return Colors.transparent;
    case ButtonStylePreset.filled:
      return AdiyogiColors.shellWhite;
    case ButtonStylePreset.gradient:
      return AdiyogiColors.shellWhite;
    case ButtonStylePreset.glass:
      return AdiyogiColors.shellWhite.withValues(alpha: 0.88);
  }
}

Color _buttonForeground(ButtonStylePreset style) {
  switch (style) {
    case ButtonStylePreset.outlined:
    case ButtonStylePreset.text:
      return AdiyogiColors.shellCharcoal;
    case ButtonStylePreset.filled:
      return AdiyogiColors.shellCharcoal;
    case ButtonStylePreset.gradient:
      return AdiyogiColors.shellCharcoal;
    case ButtonStylePreset.glass:
      return AdiyogiColors.shellCharcoal;
  }
}

Color _inputFillColor(InputStylePreset style, Color background, Color cardColor) {
  switch (style) {
    case InputStylePreset.filled:
      return cardColor;
    case InputStylePreset.floatingLabel:
      return background;
    case InputStylePreset.rounded:
      return cardColor;
    case InputStylePreset.outlined:
      return background;
    case InputStylePreset.underline:
      return Colors.transparent;
  }
}

EdgeInsets _paddingForInput(InputStylePreset style, EdgeInsets base) {
  switch (style) {
    case InputStylePreset.underline:
      return const EdgeInsets.symmetric(horizontal: 0, vertical: 10);
    case InputStylePreset.filled:
    case InputStylePreset.floatingLabel:
    case InputStylePreset.rounded:
    case InputStylePreset.outlined:
      return base;
  }
}

double _borderWidth(BorderStylePreset style) {
  switch (style) {
    case BorderStylePreset.none:
      return 0;
    case BorderStylePreset.thin:
      return 1;
    case BorderStylePreset.medium:
      return 2;
    case BorderStylePreset.thick:
      return 3;
  }
}

List<BoxShadow> _shadowForCard(ShadowPreset level) {
  switch (level) {
    case ShadowPreset.none:
      return const [];
    case ShadowPreset.small:
      return const [
        BoxShadow(color: Color(0x0A121218), blurRadius: 8, offset: Offset(0, 4)),
      ];
    case ShadowPreset.medium:
      return const [
        BoxShadow(color: Color(0x14121218), blurRadius: 14, offset: Offset(0, 8)),
      ];
    case ShadowPreset.large:
      return const [
        BoxShadow(color: Color(0x20121218), blurRadius: 24, offset: Offset(0, 12)),
      ];
  }
}
