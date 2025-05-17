part of 'trial_bloc.dart';

abstract class TrialState extends Equatable {
  const TrialState();

  @override
  List<Object> get props => [];
}

class TrialInitial extends TrialState {}

class TrialInProgress extends TrialState {}

class TrialSuccess extends TrialState {}

class TrialFailure extends TrialState {}

/// ✅ **Denied States Only Contain Logic (Not `TypeData`)**
class AccessFilterFeatureDenied extends TrialState {}

class AccessMultiClosetFeatureDenied extends TrialState {}

class AccessCustomizeFeatureDenied extends TrialState {}

class AccessCalendarFeatureDenied extends TrialState {}

class AccessUsageAnalyticsFeatureDenied extends TrialState {}

class AccessOutfitCreationFeatureDenied extends TrialState {}

/// ✅ **Unified Denied State (If Multiple Features Are Denied)**
class TrialAccessDenied extends TrialState {
  final List<TrialState> deniedStates;

  const TrialAccessDenied(this.deniedStates);

  @override
  List<Object> get props => [deniedStates];
}

class TrialActivationInProgress extends TrialState {}

class TrialActivated extends TrialState {}

class TrialActivationFailed extends TrialState {}

class TrialEndedSuccessState extends TrialState {}
