part of 'first_time_scenario_bloc.dart';

abstract class FirstTimeScenarioEvent {}

class CheckFirstTimeScenario extends FirstTimeScenarioEvent {}

class SavePersonalizationFlowTypeEvent extends FirstTimeScenarioEvent {
  final OnboardingJourneyType flowType;

  SavePersonalizationFlowTypeEvent(this.flowType);
}
