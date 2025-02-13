import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utilities/logger.dart';
import '../../../core_enums.dart';
import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';

part 'customize_event.dart';
part 'customize_state.dart';

class CustomizeBloc extends Bloc<CustomizeEvent, CustomizeState> {
  final CustomLogger logger;
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;

  CustomizeBloc({
    required this.coreFetchService,
    required this.coreSaveService,
  })
      : logger = CustomLogger('ArrangeBlocLogger'),
        super(const CustomizeState(
        gridSize: 3,
        sortCategory: 'updated_at',
        sortOrder: 'DESC',
        saveStatus: SaveStatus.initial,
      )) {
    on<LoadCustomizeEvent>(_onLoadCustomize);
    on<UpdateCustomizeEvent>(_onUpdateCustomize);
    on<SaveCustomizeEvent>(_onSaveCustomize);
    on<ResetCustomizeEvent>(_onResetCustomize);
    on<CheckCustomizeAccessEvent>(_onCheckCustomizeAccess);
  }

  Future<void> _onLoadCustomize(LoadCustomizeEvent event,
      Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      final settings = await coreFetchService.fetchArrangementSettings();
      final gridSize = settings['grid'] as int? ?? 3;
      final sortCategory = settings['sort'] as String? ?? 'updated_at';
      final sortOrder = settings['sort_order'] as String? ?? 'ASC';

      emit(state.copyWith(
        gridSize: gridSize,
        sortCategory: sortCategory,
        sortOrder: sortOrder,
        saveStatus: SaveStatus.loadSuccess,
      ));
    } catch (error) {
      logger.e('Error loading arrangement: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onUpdateCustomize(UpdateCustomizeEvent event,
      Emitter<CustomizeState> emit) async {
    emit(state.copyWith(
      gridSize: event.gridSize ?? state.gridSize,
      sortCategory: event.sortCategory ?? state.sortCategory,
      sortOrder: event.sortOrder ?? state.sortOrder,
    ));
  }

  Future<void> _onSaveCustomize(SaveCustomizeEvent event,
      Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      await coreSaveService.saveArrangementSettings(
        gridSize: state.gridSize,
        sortCategory: state.sortCategory,
        sortOrder: state.sortOrder,
      );
      emit(state.copyWith(saveStatus: SaveStatus.saveSuccess));
    } catch (error) {
      logger.e('Error saving arrangement: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onResetCustomize(ResetCustomizeEvent event,
      Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      await coreSaveService.resetArrangementSettings();
      emit(const CustomizeState(
        gridSize: 3,
        sortCategory: 'updated_at',
        sortOrder: 'ASC',
        saveStatus: SaveStatus.success,
      ));
    } catch (error) {
      logger.e('Error resetting arrangement: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onCheckCustomizeAccess(CheckCustomizeAccessEvent event,
      Emitter<CustomizeState> emit) async {
    logger.i('Checking if the user has access to the customize pages.');

    try {
      // Step 1: Check if user already has access via milestones, purchases, etc.
      bool hasCustomizeAccess = await coreFetchService.accessCustomizePage();

      if (hasCustomizeAccess) {
        emit(state.copyWith(accessStatus: AccessStatus.granted));
        logger.i('User already has customize access via milestones/purchase.');
        return; // Exit early since access is granted
      }

      // Step 2: If no access, check trial status
      logger.w('User does not have customize access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        logger.i('Trial is pending. Navigating to trialStarted.');
        emit(state.copyWith(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Trial not pending. Navigating to payment screen.');
        emit(state.copyWith(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error checking customize access: $error');
      emit(state.copyWith(accessStatus: AccessStatus.error));
    }
  }
}