import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../data/models/filter_setting.dart';
import '../../data/models/multi_closet.dart';

part 'filter_state.dart';
part 'filter_event.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final CustomLogger logger;
  final CoreFetchService fetchService;
  final CoreSaveService saveService;

  FilterBloc({
    required this.fetchService,
    required this.saveService,
  }) : logger = CustomLogger('FilterBlocLogger'),
        super(const FilterState()) {
    logger.i('FilterBloc initialized');
    on<LoadFilterEvent>(_onLoadFilter);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<SaveFilterEvent>(_onSaveFilter);
    on<ResetFilterEvent>(_onResetFilter);
    on<CheckFilterAccessEvent>(_onCheckFilterAccess);
  }

  Future<void> _onLoadFilter(LoadFilterEvent event, Emitter<FilterState> emit) async {
    logger.i('Loading filter settings...');
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));

    try {
      // Fetch all closets for the user
      final closetData = await fetchService.fetchAllClosets();
      logger.i('Fetched all closets successfully: ${closetData.length} items');

      final allClosetsDisplay = closetData.map((closetMap) => MultiCloset.fromMap(closetMap)).toList();

      final filterData = await fetchService.fetchFilterSettings();
      logger.i('Filter settings loaded successfully');

      final FilterSettings filterSettings = filterData['filters'];
      final selectedClosetId = filterData['selectedClosetId'] as String;
      final allCloset = filterData['allCloset'] as bool;
      final ignoreItemName = filterData['ignoreItemName'] as bool;
      final itemName = filterData['itemName'] as String;

      emit(state.copyWith(
        saveStatus: SaveStatus.loadSuccess,
        allClosetsDisplay: allClosetsDisplay,
        itemType: filterSettings.itemType,
        occasion: filterSettings.occasion,
        season: filterSettings.season,
        colour: filterSettings.colour,
        colourVariations: filterSettings.colourVariations,
        clothingType: filterSettings.clothingType,
        clothingLayer: filterSettings.clothingLayer,
        shoesType: filterSettings.shoesType,
        accessoryType: filterSettings.accessoryType,
        selectedClosetId: selectedClosetId,
        allCloset: allCloset,
        ignoreItemName: ignoreItemName,
        searchQuery: itemName,
      ));
      logger.i('Filter settings state updated successfully');
    } catch (error) {
      logger.e('Error fetching filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  void _onUpdateFilter(UpdateFilterEvent event, Emitter<FilterState> emit) {
    logger.i('Updating filter settings with event: $event');

    emit(state.copyWith(
      searchQuery: event.searchQuery ?? state.searchQuery,
      itemType: event.itemType ?? state.itemType,
      occasion: event.occasion ?? state.occasion,
      season: event.season ?? state.season,
      colour: event.colour ?? state.colour,
      colourVariations: event.colourVariations ?? state.colourVariations,
      clothingType: event.clothingType ?? state.clothingType,
      clothingLayer: event.clothingLayer ?? state.clothingLayer,
      shoesType: event.shoesType ?? state.shoesType,
      accessoryType: event.accessoryType ?? state.accessoryType,
      allCloset: event.allCloset ?? state.allCloset,
      selectedClosetId: event.selectedClosetId ?? state.selectedClosetId,
    ));

    logger.i('Filter settings updated with new state: ${state.toString()}');
  }

  Future<void> _onSaveFilter(SaveFilterEvent event, Emitter<FilterState> emit) async {
    logger.i('Saving filter settings...');
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));

    try {
      final filterSettings = FilterSettings(
        itemType: state.itemType,
        occasion: state.occasion,
        season: state.season,
        colour: state.colour,
        colourVariations: state.colourVariations,
        clothingType: state.clothingType,
        clothingLayer: state.clothingLayer,
        shoesType: state.shoesType,
        accessoryType: state.accessoryType,
      );

      final isSuccess = await saveService.saveFilterSettings(
        filterSettings: filterSettings,
        selectedClosetId: state.selectedClosetId,
        allCloset: state.allCloset,
        ignoreItemName: state.ignoreItemName,
        itemName: state.searchQuery,
      );

      if (isSuccess) {
        emit(state.copyWith(saveStatus: SaveStatus.saveSuccess));
        logger.i('Filter settings saved successfully');
      } else {
        emit(state.copyWith(saveStatus: SaveStatus.failure));
        logger.w('Filter settings save failed without an error');
      }
    } catch (error) {
      logger.e('Error saving filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onResetFilter(ResetFilterEvent event, Emitter<FilterState> emit) async {
    logger.i('Resetting filter settings to default');
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));

    try {
      final result = await saveService.saveDefaultSelection();
      logger.i('Default filter settings loaded successfully');

      emit(state.copyWith(
        saveStatus: SaveStatus.saveSuccess,
        itemType: result['filters']['itemType'],
        occasion: result['filters']['occasion'],
        season: result['filters']['season'],
        colour: result['filters']['colour'],
        colourVariations: result['filters']['colourVariations'],
        clothingType: result['filters']['clothingType'],
        clothingLayer: result['filters']['clothingLayer'],
        shoesType: result['filters']['shoesType'],
        accessoryType: result['filters']['accessoryType'],
        selectedClosetId: result['selectedClosetId'],
        allCloset: result['allCloset'],
        ignoreItemName: result['ignoreItemName'],
      ));
      logger.i('Filter settings reset and state updated');
    } catch (error) {
      logger.e('Error resetting filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onCheckFilterAccess(
      CheckFilterAccessEvent event,
      Emitter<FilterState> emit) async {
    logger.i('Checking if the user has access to the filter page.');

    try {
      bool canAccessFilterPage = await fetchService.accessFilterPage();

      if (canAccessFilterPage) {
        emit(state.copyWith(accessStatus: AccessStatus.granted));
        logger.i('Filter page access granted.');
      } else {
        emit(state.copyWith(accessStatus: AccessStatus.denied));
        logger.w('Filter access denied.');
      }
    } catch (error) {
      logger.e('Error checking filter access: $error');
      emit(state.copyWith(accessStatus: AccessStatus.error));
    }
  }
}
