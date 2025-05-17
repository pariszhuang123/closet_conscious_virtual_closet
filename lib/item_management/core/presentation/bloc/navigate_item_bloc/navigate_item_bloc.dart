import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../data/services/item_fetch_service.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../../user_management/user_service_locator.dart';

part 'navigate_item_event.dart';
part 'navigate_item_state.dart';

class NavigateItemBloc extends Bloc<NavigateItemEvent, NavigateItemState> {
  final ItemFetchService itemFetchService;
  final CoreFetchService coreFetchService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  NavigateItemBloc({
    required this.coreFetchService,
    required this.itemFetchService, // Require it
    CustomLogger? logger,
    AuthBloc? authBloc,
  })  : logger = logger ?? CustomLogger('NavigateItemBlocLogger'),
        authBloc = authBloc ?? locator<AuthBloc>(),
        super(InitialNavigateItemState()) {
    on<FetchDisappearedClosetsEvent>(_onFetchDisappearedClosets);
  }

  Future<void> _onFetchDisappearedClosets(
      FetchDisappearedClosetsEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchDisappearedClosetsInProgressState());

    try {
      final updatedClosets = await itemFetchService.updateDisappearedClosets();

      if (updatedClosets.isNotEmpty) {
        // Extract details of the first closet from the response
        final firstCloset = updatedClosets.first;
        final closetId = firstCloset['closet_id'] as String;
        final closetImage = firstCloset['closet_image'] as String;
        final closetName = firstCloset['closet_name'] as String;

        logger.i('Successfully updated closet: $closetId');
        emit(FetchDisappearedClosetsSuccessState(
          closetId: closetId,
          closetImage: closetImage,
          closetName: closetName,
        ));
      } else {
        logger.i('No closets were updated.');
        emit(const NavigateItemFailureState(error: 'No closets to update.'));
      }
    } catch (error) {
      logger.e('Error fetching disappeared closets: $error');
      emit(NavigateItemFailureState(error: error.toString()));
    }
  }
}
