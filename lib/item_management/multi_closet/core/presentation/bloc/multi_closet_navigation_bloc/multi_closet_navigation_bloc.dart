import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/data/services/core_save_services.dart';
import '../../../../../../core/utilities/logger.dart';

part 'multi_closet_navigation_event.dart';
part 'multi_closet_navigation_state.dart';

class MultiClosetNavigationBloc extends Bloc<MultiClosetNavigationEvent, MultiClosetNavigationState> {
  final CoreFetchService fetchService;
  final CoreSaveService saveService;
  final CustomLogger logger;

  MultiClosetNavigationBloc({
    required this.fetchService,
    required this.saveService,
  })  : logger = CustomLogger('MultiClosetNavigationBloc'),
        super(ViewMultiClosetNavigationState()) {
    on<NavigateToViewMultiCloset>((event, emit) {
      logger.d('Navigating to ViewMultiCloset.');
      emit(ViewMultiClosetNavigationState());
    });

    on<NavigateToCreateMultiCloset>((event, emit) {
      logger.d('Navigating to CreateMultiCloset.');
      emit(CreateMultiClosetNavigationState());
    });

    on<NavigateToEditAllMultiCloset>(_onNavigateToEditAllMultiCloset);

    on<NavigateToEditSingleMultiCloset>(_onNavigateToEditSingleMultiCloset);

    on<NavigateToFilterProvider>((event, emit) {
      logger.d('Navigating to FilterProvider.');
      emit(FilterProviderNavigationState());
    });

    on<NavigateToCustomizeProvider>((event, emit) {
      logger.d('Navigating to CustomizeProvider.');
      emit(CustomizeProviderNavigationState());
    });

    on<CheckMultiClosetAccessEvent>(_onCheckMultiClosetAccess);
  }

  Future<void> _onNavigateToEditAllMultiCloset(
      NavigateToEditAllMultiCloset event, Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Starting navigation to EditAllMultiCloset.');
    try {
      await saveService.updateAllClosetSharedPreference();
      logger.d('Shared preference for all closets updated successfully.');
      emit(EditAllMultiClosetNavigationState());
    } catch (error) {
      logger.e('Error navigating to EditAllMultiCloset: $error');
      emit(MultiClosetNavigationErrorState());
    }
  }

  Future<void> _onNavigateToEditSingleMultiCloset(
      NavigateToEditSingleMultiCloset event, Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Starting navigation to EditSingleMultiCloset for closetId: ${event.closetId}.');
    try {
      await saveService.updateSingleClosetSharedPreference(event.closetId);
      logger.d('Shared preference updated for closetId: ${event.closetId}.');
      emit(EditSingleMultiClosetNavigationState(event.closetId));
    } catch (error) {
      logger.e('Error navigating to EditSingleMultiCloset: $error');
      emit(MultiClosetNavigationErrorState());
    }
  }

  Future<void> _onCheckMultiClosetAccess(
      CheckMultiClosetAccessEvent event, Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Checking multi-closet access.');
    try {
      final hasAccess = await fetchService.checkMultiClosetFeature();
      logger.d('Multi-closet access check result: $hasAccess.');
      if (hasAccess) {
        emit(MultiClosetAccessGrantedState());
      } else {
        emit(MultiClosetAccessDeniedState());
      }
    } catch (error) {
      logger.e('Error checking multi-closet access: $error');
      emit(MultiClosetNavigationErrorState());
    }
  }
}
