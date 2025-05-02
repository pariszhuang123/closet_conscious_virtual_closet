import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../data/models/filter_setting.dart';
import '../../../../item_management/multi_closet/core/data/models/multi_closet_minimal.dart';

part 'filter_state.dart';
part 'filter_event.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final CustomLogger logger;
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;

  FilterBloc({
    required this.coreFetchService,
    required this.coreSaveService,
  }) : logger = CustomLogger('FilterBlocLogger'),
        super(const FilterState()) {
    logger.i('FilterBloc initialized');

    // 1️⃣ Kick off the sequence
    on<FilterStarted>(_onFilterStarted);
    // 2️⃣ Access check
    on<CheckFilterAccessEvent>(_onCheckFilterAccess);
    // 3️⃣ Multi-closet feature
    on<CheckMultiClosetFeatureEvent>(_onCheckMultiClosetFeature);
    // 4️⃣ Load saved filters
    on<LoadFilterEvent>(_onLoadFilter);
    // Other existing handlers
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<SaveFilterEvent>(_onSaveFilter);
    on<ResetFilterEvent>(_onResetFilter);
  }

  Future<void> _onFilterStarted(FilterStarted event, Emitter<FilterState> emit) async {
    // Optionally show a spinner
    emit(state.copyWith(saveStatus: SaveStatus.initial));
    // Start by checking access
    add(CheckFilterAccessEvent());
  }

  Future<void> _onCheckFilterAccess(
      CheckFilterAccessEvent event,
      Emitter<FilterState> emit
      ) async {
    logger.i('Checking filter access...');
    try {
      final hasAccess = await coreFetchService.accessFilterPage();
      if (hasAccess) {
        emit(state.copyWith(accessStatus: AccessStatus.granted));
        // Now check multi-closet feature
        add(CheckMultiClosetFeatureEvent());
      } else if (await coreFetchService.isTrialPending()) {
        emit(state.copyWith(accessStatus: AccessStatus.trialPending));
      } else {
        emit(state.copyWith(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error in access check: $error');
      emit(state.copyWith(accessStatus: AccessStatus.error));
    }
  }

  Future<void> _onCheckMultiClosetFeature(
      CheckMultiClosetFeatureEvent event,
      Emitter<FilterState> emit
      ) async {
    logger.i('Checking multi-closet feature...');
    try {
      final hasFeature = await coreFetchService.checkMultiClosetFeature();
      emit(state.copyWith(hasMultiClosetFeature: hasFeature));
      // Now load the actual filters
      add(LoadFilterEvent());
    } catch (error) {
      logger.e('Error checking multi-closet feature: $error');
      emit(state.copyWith(hasMultiClosetFeature: false));
      add(LoadFilterEvent());
    }
  }

  Future<void> _onLoadFilter(
      LoadFilterEvent event,
      Emitter<FilterState> emit
      ) async {
    logger.i('Loading filter settings...');
    emit(state.copyWith(saveStatus: SaveStatus.inProgress));
    try {
      final closetData = await coreFetchService.fetchPermanentClosets();
      final allClosetsDisplay = closetData
          .map((map) => MultiClosetMinimal.fromMap(map))
          .toList();

      final filterData = await coreFetchService.fetchFilterSettings();
      final settings = filterData['filters'] as FilterSettings;

      emit(state.copyWith(
        saveStatus: SaveStatus.loadSuccess,
        allClosetsDisplay: allClosetsDisplay,
        itemType: settings.itemType,
        occasion: settings.occasion,
        season: settings.season,
        colour: settings.colour,
        colourVariations: settings.colourVariations,
        clothingType: settings.clothingType,
        clothingLayer: settings.clothingLayer,
        shoesType: settings.shoesType,
        accessoryType: settings.accessoryType,
        selectedClosetId: filterData['selectedClosetId'] as String,
        allCloset: filterData['allCloset'] as bool,
        onlyItemsUnworn: !(filterData['onlyItemsUnworn'] as bool),
        itemName: (filterData['ignoreItemName'] as bool)
            ? '' : filterData['itemName'] as String,
      ));
    } catch (error) {
      logger.e('Error loading filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }


  void _onUpdateFilter(UpdateFilterEvent event, Emitter<FilterState> emit) {
    logger.i('Updating filter settings with event: $event');

    // Determine which item types were previously selected
    final previousItemType = state.itemType ?? [];
    final updatedItemType = event.itemType ?? state.itemType;

    // Check if 'clothing' was deselected
    bool clothingDeselected = previousItemType.contains('clothing') && !(updatedItemType?.contains('clothing') ?? false);

    // Check if 'shoes' was deselected
    bool shoesDeselected = previousItemType.contains('shoes') && !(updatedItemType?.contains('shoes') ?? false);

    // Check if 'accessory' was deselected
    bool accessoryDeselected = previousItemType.contains('accessory') && !(updatedItemType?.contains('accessory') ?? false);

    // Check if 'black' or 'white' was selected in colour to determine if colourVariations should be cleared
    final updatedColour = event.colour ?? state.colour;
    bool resetColourVariations = updatedColour?.contains('black') == true || updatedColour?.contains('white') == true;

    // Emit the new state with permanent resets for deselected fields
    emit(state.copyWith(
      itemName: event.itemName ?? state.itemName,
      itemType: updatedItemType,
      occasion: event.occasion ?? state.occasion,
      season: event.season ?? state.season,
      colour: updatedColour,
      colourVariations: resetColourVariations ? [] : (event.colourVariations ?? state.colourVariations),
      clothingType: clothingDeselected ? [] : (event.clothingType ?? state.clothingType),
      clothingLayer: clothingDeselected ? [] : (event.clothingLayer ?? state.clothingLayer),
      shoesType: shoesDeselected ? [] : (event.shoesType ?? state.shoesType),
      accessoryType: accessoryDeselected ? [] : (event.accessoryType ?? state.accessoryType),
      onlyItemsUnworn: event.onlyItemsUnworn ?? state.onlyItemsUnworn, // Invert the value
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

      final isSuccess = await coreSaveService.saveFilterSettings(
        filterSettings: filterSettings,
        selectedClosetId: state.selectedClosetId,
        onlyItemsUnworn: !state.onlyItemsUnworn,
        allCloset: state.allCloset,
        itemName: state.itemName,
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
      final result = await coreSaveService.saveDefaultSelection();
      logger.i('Default filter settings loaded successfully');

      emit(state.copyWith(
        saveStatus: SaveStatus.success,
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
        onlyItemsUnworn: result['onlyItemsUnworn'],
        allCloset: result['allCloset'],
        itemName: result['itemName'] ?? '',
      ));
      logger.i('Filter settings reset and state updated');
    } catch (error) {
      logger.e('Error resetting filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }
}
