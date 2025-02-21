part of 'usage_analytics_navigation_bloc.dart';

abstract class UsageAnalyticsNavigationState extends Equatable {
  const UsageAnalyticsNavigationState();

  @override
  List<Object?> get props => [];
}

class UsageAnalyticsNavigationInitialState extends UsageAnalyticsNavigationState {}

class UsageAnalyticsNavigationErrorState extends UsageAnalyticsNavigationState {}

class UsageAnalyticsAccessState extends UsageAnalyticsNavigationState {
  final AccessStatus accessStatus;

  const UsageAnalyticsAccessState({this.accessStatus = AccessStatus.pending});

  UsageAnalyticsAccessState copyWith({AccessStatus? accessStatus}) {
    return UsageAnalyticsAccessState(
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object> get props => [accessStatus];
}