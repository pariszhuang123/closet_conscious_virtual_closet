import 'package:flutter/widgets.dart';
import '../../../data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

String getFlowSpecificTrialExplanation({
  required OnboardingJourneyType flowType,
  required TypeData typeData,
  required BuildContext context,
}) {
  final l10n = S.of(context);

  switch (flowType) {
    case OnboardingJourneyType.memoryFlow:
      return _getMemoryFlowExplanation(typeData, l10n);
    case OnboardingJourneyType.personalStyleFlow:
      return _getPersonalStyleExplanation(typeData, l10n);
    case OnboardingJourneyType.lifeChangeFlow:
      return _getLifeChangeExplanation(typeData, l10n);
    case OnboardingJourneyType.defaultFlow:
    default:
      return _getDefaultExplanation(typeData, l10n);
  }
}

String _getDefaultExplanation(TypeData typeData, S l10n) {
  switch (typeData.key) {
    case 'filter_filter':
      return l10n.trialIncludedFilter;
    case 'arrange':
      return l10n.trialIncludedCustomize;
    case 'addCloset_addCloset':
      return l10n.trialIncludedClosets;
    case 'outfits_upload':
      return l10n.trialIncludedOutfits;
    case 'calendar':
      return l10n.trialIncludedCalendar;
    case 'UsageInsights':
      return l10n.trialIncludedDrawerInsights;
    default:
      return '';
  }
}

String _getMemoryFlowExplanation(TypeData typeData, S l10n) {
  switch (typeData.key) {
    case 'filter_filter':
      return l10n.memoryTrialFilter;
    case 'arrange':
      return l10n.memoryTrialCustomize;
    case 'addCloset_addCloset':
      return l10n.memoryTrialClosets;
    case 'outfits_upload':
      return l10n.memoryTrialOutfits;
    case 'calendar':
      return l10n.memoryTrialCalendar;
    case 'UsageInsights':
      return l10n.memoryTrialInsights;
    default:
      return '';
  }
}

String _getPersonalStyleExplanation(TypeData typeData, S l10n) {
  switch (typeData.key) {
    case 'filter_filter':
      return l10n.personalStyleTrialFilter;
    case 'arrange':
      return l10n.personalStyleTrialCustomize;
    case 'addCloset_addCloset':
      return l10n.personalStyleTrialClosets;
    case 'outfits_upload':
      return l10n.personalStyleTrialOutfits;
    case 'calendar':
      return l10n.personalStyleTrialCalendar;
    case 'UsageInsights':
      return l10n.personalStyleTrialInsights;
    default:
      return '';
  }
}

String _getLifeChangeExplanation(TypeData typeData, S l10n) {
  switch (typeData.key) {
    case 'filter_filter':
      return l10n.lifeChangeTrialFilter;
    case 'arrange':
      return l10n.lifeChangeTrialCustomize;
    case 'addCloset_addCloset':
      return l10n.lifeChangeTrialClosets;
    case 'outfits_upload':
      return l10n.lifeChangeTrialOutfits;
    case 'calendar':
      return l10n.lifeChangeTrialCalendar;
    case 'UsageInsights':
      return l10n.lifeChangeTrialInsights;
    default:
      return '';
  }
}
