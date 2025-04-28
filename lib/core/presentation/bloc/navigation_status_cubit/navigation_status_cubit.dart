import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_status_state.dart';

class NavigationStatusCubit extends Cubit<NavigationStatusState> {
  NavigationStatusCubit() : super(const NavigationStatusState());

  void setNavigating(bool isNavigating) {
    emit(state.copyWith(isNavigating: isNavigating));
  }

  void setSnackBarShown(bool snackBarShown) {
    emit(state.copyWith(snackBarShown: snackBarShown));
  }

  void reset() {
    emit(const NavigationStatusState());
  }
}

