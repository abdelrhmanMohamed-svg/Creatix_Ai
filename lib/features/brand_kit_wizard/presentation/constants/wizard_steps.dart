import 'package:flutter/material.dart';
import '../pages/business_type_step.dart';
import '../pages/tone_of_voice_step.dart';
import '../pages/color_palette_step.dart';
import '../pages/target_audience_step.dart';
import '../pages/summary_step.dart';

enum WizardStepType {
  businessType,
  toneOfVoice,
  colorPalette,
  targetAudience,
  summary,
}

class WizardStepsConfig {
  static const int totalSteps = 5;
  static const int lastStepIndex = totalSteps - 1;

  static const List<String> _titles = [
    'Business Type',
    'Tone of Voice',
    'Colors',
    'Target Audience',
    'Summary',
  ];

  static List<String> get stepTitles => _titles;

  static String getStepTitle(int index) {
    if (index >= 0 && index < _titles.length) {
      return _titles[index];
    }
    return '';
  }

  static Widget createStep(int index, {VoidCallback? onComplete}) {
    switch (index) {
      case 0:
        return const BusinessTypeStep();
      case 1:
        return const ToneOfVoiceStep();
      case 2:
        return const ColorPaletteStep();
      case 3:
        return const TargetAudienceStep();
      case 4:
        return SummaryStep(onComplete: onComplete);
      default:
        return const SizedBox.shrink();
    }
  }
}
