import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/services/core_fetch_services.dart';

part 'multi_closet_navigation_event.dart';
part 'multi_closet_navigation_state.dart';

class MultiClosetNavigationBloc extends Bloc<MultiClosetNavigationEvent, MultiClosetNavigationState> {
  final CoreFetchService fetchService;

  MultiClosetNavigationBloc({required this.fetchService}) : super(ViewMultiClosetNavigationState()) {

    on<NavigateToViewMultiCloset>((event, emit) {
      emit(ViewMultiClosetNavigationState());
    });

    on<NavigateToCreateMultiCloset>((event, emit) {
      emit(CreateMultiClosetNavigationState());
    });

    on<NavigateToEditSingleMultiCloset>((event, emit) {
      emit(EditSingleMultiClosetNavigationState(event.closetId));
    });


    on<NavigateToEditAllMultiCloset>((event, emit) {
      emit(EditAllMultiClosetNavigationState());
    });

    on<NavigateToFilterProvider>((event, emit) {
      emit(FilterProviderNavigationState());
    });

    on<NavigateToCustomizeProvider>((event, emit) {
      emit(CustomizeProviderNavigationState());
    });

    on<CheckMultiClosetAccessEvent>(_onCheckMultiClosetAccess);
  }

  Future<void> _onCheckMultiClosetAccess(
      CheckMultiClosetAccessEvent event,
      Emitter<MultiClosetNavigationState> emit,
      ) async {
    try {
      final hasAccess = await fetchService.checkMultiClosetFeature();

      if (hasAccess) {
        emit(MultiClosetAccessGrantedState());
      } else {
        emit(MultiClosetAccessDeniedState());
      }
    } catch (error) {
      emit(MultiClosetNavigationErrorState());
    }
  }
}
