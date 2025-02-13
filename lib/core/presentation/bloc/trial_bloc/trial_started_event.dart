part of 'trial_started_bloc.dart';

/// ✅ **Base Event**
abstract class TrialEvent extends Equatable {
  const TrialEvent();

  @override
  List<Object> get props => [];
}

/// ✅ **Check all feature access (Bulk Event)**
class CheckTrialAccessEvent extends TrialEvent {}

/// ✅ **Check individual feature access (Optional)**
class CheckFilterFeatureAccessEvent extends TrialEvent {}

class CheckMultiClosetFeatureAccessEvent extends TrialEvent {}

class CheckCustomizeFeatureAccessEvent extends TrialEvent {}

class CheckCalendarFeatureAccessEvent extends TrialEvent {}

class CheckOutfitCreationFeatureAccessEvent extends TrialEvent {}

class ActivateTrialEvent extends TrialEvent {}
