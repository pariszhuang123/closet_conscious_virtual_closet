import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

class AchievementDefinition {
  final String key;

  /// Maps the flow type to a getter function for localized title
  final Map<OnboardingJourneyType, String Function(S)> titleL10nGetters;

  /// Maps the flow type to a getter function for localized message
  final Map<OnboardingJourneyType, String Function(S)> msgL10nGetters;

  const AchievementDefinition({
    required this.key,
    required this.titleL10nGetters,
    required this.msgL10nGetters,
  });
}
