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
    on<LoadFilterEvent>(_onLoadFilter);
    on<CheckMultiClosetFeatureEvent>(_onCheckMultiClosetFeature); // Add the new event handler
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
      final closetData = await coreFetchService.fetchPermanentClosets();
      logger.i('Fetched all closets successfully: ${closetData.length} items');

      final allClosetsDisplay = closetData.map((closetMap) => MultiClosetMinimal.fromMap(closetMap)).toList();

      final filterData = await coreFetchService.fetchFilterSettings();
      logger.i('Filter settings loaded successfully');

      final FilterSettings filterSettings = filterData['filters'];
      final selectedClosetId = filterData['selectedClosetId'] as String;
      final allCloset = filterData['allCloset'] as bool;
      final onlyItemsUnworn = filterData['onlyItemsUnworn'] as bool;
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
        onlyItemsUnworn: !onlyItemsUnworn,
        allCloset: allCloset,
        itemName: itemName,
      ));
      logger.i('Filter settings state updated successfully');
    } catch (error) {
      logger.e('Error fetching filters: $error');
      emit(state.copyWith(saveStatus: SaveStatus.failure));
    }
  }

  Future<void> _onCheckMultiClosetFeature(
      CheckMultiClosetFeatureEvent event, Emitter<FilterState> emit) async {
    logger.i('Checking multi_closet feature for user.');

    try {
      // Use fetchService to check if the user has multi_closet access
      final hasFeature = await coreFetchService.checkMultiClosetFeature();
      logger.i('Multi-closet feature access: $hasFeature');

      // Update state with the result
      emit(state.copyWith(hasMultiClosetFeature: hasFeature));
    } catch (error) {
      logger.e('Error checking multi_closet feature: $error');
      emit(state.copyWith(hasMultiClosetFeature: false)); // Default to false on error
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

  Future<void> _onCheckFilterAccess(
      CheckFilterAccessEvent event, Emitter<FilterState> emit) async {
    logger.i('Checking if the user has access to the filter feature.');

    try {
      // Step 1: Check if user already has access via milestones, purchases, etc.
      bool hasFilterAccess = await coreFetchService.accessFilterPage();

      if (hasFilterAccess) {
        emit(state.copyWith(accessStatus: AccessStatus.granted));
        logger.i('User already has filter access via milestones/purchase.');
        return; // Exit early since access is granted
      }

      // Step 2: If no access, check trial status
      logger.w('User does not have filter access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        logger.i('Trial is pending. Navigating to trialStarted.');
        emit(state.copyWith(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Trial not pending. Navigating to payment screen.');
        emit(state.copyWith(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error checking filter access: $error');
      emit(state.copyWith(accessStatus: AccessStatus.error));
    }
  }
}
