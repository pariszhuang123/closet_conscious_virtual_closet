import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';
import '../../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../../user_management/user_service_locator.dart';

part 'premium_feature_access_event.dart';
part 'premium_feature_access_state.dart';

class PremiumFeatureAccessBloc extends Bloc<PremiumFeatureAccessEvent, PremiumFeatureAccessState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  PremiumFeatureAccessBloc({required this.coreFetchService, required this.coreSaveService})
      : logger = CustomLogger('PremiumFeatureAccessBlocLogger'),
        authBloc = locator<AuthBloc>(),
        super(InitialNavigateCoreState()) {
    on<CheckUploadItemCreationAccessEvent>(_onCheckUploadItemCreationAccess); // Add event handler
    on<CheckEditItemCreationAccessEvent>(_onCheckEditItemCreationAccess); // Add event handler
    on<CheckSelfieCreationAccessEvent>(_onCheckSelfieCreationAccess); // Add event handler
    on<CheckEditClosetCreationAccessEvent>(_onCheckEditClosetCreationAccess); // Add event handler
    on<CheckOutfitCreationAccessEvent>(_onCheckOutfitCreationAccess);
    on<CheckCustomizeAccessEvent>(_onCheckCustomizeAccess);
  }

  Future<void> _onCheckUploadItemCreationAccess(
      CheckUploadItemCreationAccessEvent event,
      Emitter<PremiumFeatureAccessState> emit) async {
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
      Emitter<PremiumFeatureAccessState> emit) async {
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
      Emitter<PremiumFeatureAccessState> emit) async {
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
      Emitter<PremiumFeatureAccessState> emit) async {
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

  Future<void> _onCheckOutfitCreationAccess(
      CheckOutfitCreationAccessEvent event,
      Emitter<PremiumFeatureAccessState> emit,
      ) async {
    logger.i('Checking if the user has access to create multiple outfits.');
    try {
      final hasAccess = await coreFetchService.checkOutfitAccess();

      if (hasAccess) {
        emit(OutfitAccessGrantedState());
        logger.i('User has access to create multiple outfits.');
      } else {
        emit(OutfitAccessDeniedState());
        logger.i('User denied access to create multiple outfits.');
      }
    } catch (error) {
      logger.e('Error checking outfit creation access: $error');
      emit(const OutfitAccessErrorState('Failed to check outfit creation access.'));
    }
  }

  Future<void> _onCheckCustomizeAccess(
      CheckCustomizeAccessEvent event,
      Emitter<PremiumFeatureAccessState> emit,
      ) async {
    logger.i('Checking access for customize feature');
    try {
      final hasAccess = await coreFetchService.accessCustomizePage();
      if (hasAccess) {
        emit(CustomizeAccessGrantedState());
      } else {
        emit(CustomizeAccessDeniedState());
      }
    } catch (error) {
      logger.e('Error checking customize access: $error');
      emit(const CustomizeAccessErrorState('Failed to check customize access'));
    }
  }

}
