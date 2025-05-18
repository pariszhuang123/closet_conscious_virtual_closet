part of 'trial_bloc.dart';

/// ✅ **Base Event**
abstract class TrialEvent extends Equatable {
  const TrialEvent();

  @override
  List<Object> get props => [];
}

/// ✅ **Check all feature access (Bulk Event)**
class CheckTrialAccessEvent extends TrialEvent {}

/// ✅ **Check individual feature access (Optional)**
class CheckTrialAccessByFeatureEvent extends TrialEvent {
  final FeatureKey feature;

  const CheckTrialAccessByFeatureEvent(this.feature);

  @override
  List<Object> get props => [feature];
}
class ActivateTrialEvent extends TrialEvent {}

class TrialEndedEvent extends TrialEvent {}

