enum InputStylePreset {
  outlined,
  filled,
  underline,
  floatingLabel,
  rounded,
}

enum CardStylePreset {
  flat,
  border,
  shadow,
  floating,
  glass,
}

enum ButtonStylePreset {
  filled,
  outlined,
  text,
  gradient,
  glass,
}

enum BorderStylePreset {
  none,
  thin,
  medium,
  thick,
}

enum ShadowPreset {
  none,
  small,
  medium,
  large,
}

class ComponentStyleConfig {
  final InputStylePreset inputStyle;
  final CardStylePreset cardStyle;
  final ButtonStylePreset buttonStyle;
  final BorderStylePreset borderStyle;
  final ShadowPreset shadowLevel;

  const ComponentStyleConfig({
    this.inputStyle = InputStylePreset.outlined,
    this.cardStyle = CardStylePreset.border,
    this.buttonStyle = ButtonStylePreset.filled,
    this.borderStyle = BorderStylePreset.thin,
    this.shadowLevel = ShadowPreset.small,
  });

  ComponentStyleConfig copyWith({
    InputStylePreset? inputStyle,
    CardStylePreset? cardStyle,
    ButtonStylePreset? buttonStyle,
    BorderStylePreset? borderStyle,
    ShadowPreset? shadowLevel,
  }) {
    return ComponentStyleConfig(
      inputStyle: inputStyle ?? this.inputStyle,
      cardStyle: cardStyle ?? this.cardStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      borderStyle: borderStyle ?? this.borderStyle,
      shadowLevel: shadowLevel ?? this.shadowLevel,
    );
  }
}

enum ShapeStylePreset {
  square,
  slightRounded,
  rounded,
  extraRounded,
  pill,
}
