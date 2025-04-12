part of 'first_time_scenario_bloc.dart';

abstract class FirstTimeScenarioState {}

class FirstTimeInitial extends FirstTimeScenarioState {}

class FirstTimeCheckInProgress extends FirstTimeScenarioState {}

class FirstTimeCheckSuccess extends FirstTimeScenarioState {
  final bool isFirstTime;

  FirstTimeCheckSuccess(this.isFirstTime);
}

class FirstTimeCheckFailure extends FirstTimeScenarioState {}

class SaveFlowInProgress extends FirstTimeScenarioState {}

class SaveFlowSuccess extends FirstTimeScenarioState {
  final TutorialType selectedGoal;

  SaveFlowSuccess(this.selectedGoal);
}

class SaveFlowFailure extends FirstTimeScenarioState {}
