part of 'navigation_status_cubit.dart';

class NavigationStatusState {
  final bool isNavigating;
  final bool snackBarShown;

  const NavigationStatusState({
    this.isNavigating = false,
    this.snackBarShown = false,
  });

  NavigationStatusState copyWith({
    bool? isNavigating,
    bool? snackBarShown,
  }) {
    return NavigationStatusState(
      isNavigating: isNavigating ?? this.isNavigating,
      snackBarShown: snackBarShown ?? this.snackBarShown,
    );
  }
}
