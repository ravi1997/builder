import 'package:flutter/material.dart';

enum PageTransitionPreset {
  none,
  fade,
  slide,
  scale,
  push,
  flip,
}

enum SectionAnimationPreset {
  fadeIn,
  slideUp,
  expand,
  bounce,
}

enum InputAnimationPreset {
  none,
  focusGlow,
  borderAnim,
  floatingLabel,
}

enum AnimationCurvePreset {
  linear,
  ease,
  easeIn,
  easeOut,
  spring,
}

class AnimationConfig {
  final PageTransitionPreset transition;
  final SectionAnimationPreset sectionAnim;
  final InputAnimationPreset inputAnim;
  final Duration duration;
  final AnimationCurvePreset curve;

  const AnimationConfig({
    this.transition = PageTransitionPreset.fade,
    this.sectionAnim = SectionAnimationPreset.fadeIn,
    this.inputAnim = InputAnimationPreset.focusGlow,
    this.duration = const Duration(milliseconds: 300),
    this.curve = AnimationCurvePreset.ease,
  });

  AnimationConfig copyWith({
    PageTransitionPreset? transition,
    SectionAnimationPreset? sectionAnim,
    InputAnimationPreset? inputAnim,
    Duration? duration,
    AnimationCurvePreset? curve,
  }) {
    return AnimationConfig(
      transition: transition ?? this.transition,
      sectionAnim: sectionAnim ?? this.sectionAnim,
      inputAnim: inputAnim ?? this.inputAnim,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  Curve get curveWidget {
    switch (curve) {
      case AnimationCurvePreset.linear:
        return Curves.linear;
      case AnimationCurvePreset.easeIn:
        return Curves.easeIn;
      case AnimationCurvePreset.easeOut:
        return Curves.easeOut;
      case AnimationCurvePreset.spring:
        return Curves.elasticOut;
      case AnimationCurvePreset.ease:
        return Curves.easeInOut;
    }
  }
}
