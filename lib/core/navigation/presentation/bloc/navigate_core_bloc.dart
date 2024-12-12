import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utilities/logger.dart';
import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';

part 'navigate_core_event.dart';
part 'navigate_core_state.dart';

class NavigateCoreBloc extends Bloc<NavigateCoreEvent, NavigateCoreState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  NavigateCoreBloc({required this.coreFetchService, required this.coreSaveService})
      : logger = CustomLogger('NavigateCoreBlocLogger'),
        authBloc = locator<AuthBloc>(),
        super(InitialNavigateCoreState()) {
    on<CheckUploadItemCreationAccessEvent>(_onCheckUploadItemCreationAccess); // Add event handler
    on<CheckEditItemCreationAccessEvent>(_onCheckEditItemCreationAccess); // Add event handler
    on<CheckSelfieCreationAccessEvent>(_onCheckSelfieCreationAccess); // Add event handler
    on<CheckEditClosetCreationAccessEvent>(_onCheckEditClosetCreationAccess); // Add event handler
  }

  Future<void> _onCheckUploadItemCreationAccess(
      CheckUploadItemCreationAccessEvent event,
      Emitter<NavigateCoreState> emit) async {
    logger.i('Checking if the user has access to upload items.');
    try {
      final result = await coreFetchService.checkUserAccessToUploadItems();

      if (result['status'] == 'uploadItemBronze') {
        emit(BronzeUploadItemDeniedState());
        logger.i('User have yet to pay for the bronze upload item tier.');
      } else if (result['status'] == 'uploadItemSilver') {
        emit(SilverUploadItemDeniedState());
        logger.i('User have yet to pay for the silver upload item tier.');
      } else if (result['status'] == 'uploadItemGold') {
        emit(GoldUploadItemDeniedState());
        logger.i('User have yet to pay for the gold upload item tier.');
      } else {
        emit(ItemAccessGrantedState());
        logger.w('User can upload items.');
      }
    } catch (error) {
      logger.e('Error checking upload item access: $error');
      emit(const ItemAccessErrorState('Failed to check upload item access.'));
    }
  }

  Future<void> _onCheckEditItemCreationAccess(
      CheckEditItemCreationAccessEvent event,
      Emitter<NavigateCoreState> emit) async {
    logger.i('Checking if the user has access to edit items.');
    try {
      final result = await coreFetchService.checkUserAccessToEditItems();

      if (result['status'] == 'editItemBronze') {
        emit(BronzeEditItemDeniedState());
        logger.i('User have yet to pay for the bronze edit item tier.');
      } else if (result['status'] == 'editItemSilver') {
        emit(SilverEditItemDeniedState());
        logger.i('User have yet to pay for the silver edit item tier.');
      } else if (result['status'] == 'editItemGold') {
        emit(GoldEditItemDeniedState());
        logger.i('User have yet to pay for the gold edit item tier.');
      } else {
        emit(ItemAccessGrantedState());
        logger.w('User can edit items.');
      }
    } catch (error) {
      logger.e('Error checking edit item access: $error');
      emit(const ItemAccessErrorState('Failed to check edit item access.'));
    }
  }

  Future<void> _onCheckSelfieCreationAccess(
      CheckSelfieCreationAccessEvent event,
      Emitter<NavigateCoreState> emit) async {
    logger.i('Checking if the user has access to selfie.');
    try {
      final result = await coreFetchService.checkUserAccessToSelfie();

      if (result['status'] == 'selfieBronze') {
        emit(BronzeSelfieDeniedState());
        logger.i('User have yet to pay for the bronze selfie tier.');
      } else if (result['status'] == 'selfieSilver') {
        emit(SilverSelfieDeniedState());
        logger.i('User have yet to pay for the silver selfie tier.');
      } else if (result['status'] == 'selfieGold') {
        emit(GoldSelfieDeniedState());
        logger.i('User have yet to pay for the gold selfie tier.');
      } else {
        emit(ItemAccessGrantedState());
        logger.w('User can take selfie.');
      }
    } catch (error) {
      logger.e('Error checking selfie access: $error');
      emit(const ItemAccessErrorState('Failed to check selfie access.'));
    }
  }

  Future<void> _onCheckEditClosetCreationAccess(
      CheckEditClosetCreationAccessEvent event,
      Emitter<NavigateCoreState> emit) async {
    logger.i('Checking if the user has access to edit closet photo.');
    try {
      final result = await coreFetchService.checkUserAccessToEditCloset();

      if (result['status'] == 'editClosetBronze') {
        emit(BronzeEditClosetDeniedState());
        logger.i('User have yet to pay for the bronze edit closet tier.');
      } else if (result['status'] == 'editClosetSilver') {
        emit(SilverEditClosetDeniedState());
        logger.i('User have yet to pay for the silver edit closet tier.');
      } else if (result['status'] == 'editClosetGold') {
        emit(GoldEditClosetDeniedState());
        logger.i('User have yet to pay for the gold edit closet tier.');
      } else {
        emit(ClosetAccessGrantedState());
        logger.w('User can edit closet.');
      }
    } catch (error) {
      logger.e('Error checking edit closet access: $error');
      emit(const ClosetAccessErrorState('Failed to check edit closet access.'));
    }
  }

}
