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
    on<CustomizeStarted>(_onCustomizeStarted); // ✅ Add here
    on<LoadCustomizeEvent>(_onLoadCustomize);
    on<UpdateCustomizeEvent>(_onUpdateCustomize);
    on<SaveCustomizeEvent>(_onSaveCustomize);
    on<ResetCustomizeEvent>(_onResetCustomize);
  }

  Future<void> _onCustomizeStarted(
      CustomizeStarted event,
      Emitter<CustomizeState> emit,
      ) async {
    logger.i('CustomizeStarted triggered – checking access...');

    emit(state.copyWith(saveStatus: SaveStatus.initial));

    try {
      final hasAccess = await coreFetchService.accessCustomizePage();

      if (hasAccess) {
        logger.i('Access granted. Loading customize settings...');
        emit(state.copyWith(accessStatus: AccessStatus.granted));
        add(LoadCustomizeEvent());
      } else if (await coreFetchService.isTrialPending()) {
        logger.i('Trial is pending.');
        emit(state.copyWith(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Access denied.');
        emit(state.copyWith(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error during CustomizeStarted sequence: $error');
      emit(state.copyWith(accessStatus: AccessStatus.error));
    }
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
}