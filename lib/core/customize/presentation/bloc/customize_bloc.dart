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
  final CoreFetchService fetchService;
  final CoreSaveService saveService;

  CustomizeBloc({
    required this.fetchService,
    required this.saveService,
  }) : logger = CustomLogger('ArrangeBlocLogger'),
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
  }

  Future<void> _onLoadCustomize(LoadCustomizeEvent event, Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      final settings = await fetchService.fetchArrangementSettings();
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

  Future<void> _onUpdateCustomize(UpdateCustomizeEvent event, Emitter<CustomizeState> emit) async {
    emit(state.copyWith(
      gridSize: event.gridSize ?? state.gridSize,
      sortCategory: event.sortCategory ?? state.sortCategory,
      sortOrder: event.sortOrder ?? state.sortOrder,
    ));
  }

  Future<void> _onSaveCustomize(SaveCustomizeEvent event, Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      await saveService.saveArrangementSettings(
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

  Future<void> _onResetCustomize(ResetCustomizeEvent event, Emitter<CustomizeState> emit) async {
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      await saveService.resetArrangementSettings();
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

