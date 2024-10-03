import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:closet_conscious/core/utilities/logger.dart';
import 'package:closet_conscious/item_management/core/data/models/closet_item_minimal.dart';
import 'package:closet_conscious/outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_fetch_services.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_save_services.dart';
import 'package:closet_conscious/outfit_management/core/outfit_enums.dart';


class MockOutfitFetchService extends Mock implements OutfitFetchService {}

class MockOutfitSaveService extends Mock implements OutfitSaveService {}

class MockLogger extends Mock implements CustomLogger {}

void main() {
  // Register fallback value for OutfitItemCategory
  setUpAll(() {
    registerFallbackValue(OutfitItemCategory.clothing); // or any value from OutfitItemCategory
  });

  late CreateOutfitItemBloc bloc;
  late MockOutfitFetchService mockOutfitFetchService;
  late MockOutfitSaveService mockOutfitSaveService;

  setUp(() {
    mockOutfitFetchService = MockOutfitFetchService();
    mockOutfitSaveService = MockOutfitSaveService();

    bloc = CreateOutfitItemBloc(mockOutfitFetchService, mockOutfitSaveService);
  });

  tearDown(() {
    bloc.close();
  });

  group('CreateOutfitItemBloc', () {
    test('initial state is CreateOutfitItemState.initial()', () {
      expect(bloc.state, CreateOutfitItemState.initial());
    });

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, success] when FetchMoreItemsEvent is successful',
      build: () {
        when(() => mockOutfitFetchService.fetchCreateOutfitItems(any(), any(), any()))
            .thenAnswer((_) async => [
          ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00')),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMoreItemsEvent()),
      expect: () => [
        bloc.state.copyWith(
          items: [
            ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00')),
          ],
          currentPage: 1,
          hasReachedMax: true,
          saveStatus: SaveStatus.success,
        ),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, failure] when FetchMoreItemsEvent fails',
      build: () {
        when(() => mockOutfitFetchService.fetchCreateOutfitItems(any(), any(), any()))
            .thenThrow(Exception('fetch error'));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMoreItemsEvent()),
      expect: () => [
        bloc.state.copyWith(saveStatus: SaveStatus.failure),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits state with selected item when ToggleSelectItemEvent is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const ToggleSelectItemEvent(OutfitItemCategory.clothing, '1')), // Correct types
      expect: () => [
        bloc.state.copyWith(
          selectedItemIds: {
            OutfitItemCategory.clothing: ['1'], // Using OutfitItemCategory.clothing
          },
          hasSelectedItems: true,
        ),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits state with deselected item when ToggleSelectItemEvent is added for an already selected item',
      build: () => bloc,
      seed: () => bloc.state.copyWith(
        selectedItemIds: {
          OutfitItemCategory.clothing: ['1'],
        },
      ),
      act: (bloc) => bloc.add(const ToggleSelectItemEvent(OutfitItemCategory.clothing, '1')),
      expect: () => [
        bloc.state.copyWith(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          hasSelectedItems: false,
        ),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits [success] when SaveOutfitEvent is successful',
      build: () {
        when(() => mockOutfitSaveService.saveOutfitItems(
            allSelectedItemIds: any(named: 'allSelectedItemIds')))
            .thenAnswer((_) async => {'status': 'success', 'outfit_id': '123'});
        return bloc;
      },
      seed: () => bloc.state.copyWith(
        selectedItemIds: {
          OutfitItemCategory.clothing: ['1'],
        },
      ),
      act: (bloc) => bloc.add(const SaveOutfitEvent()),
      skip: 1,
      expect: () => [
        // Only testing the success state
        bloc.state.copyWith(saveStatus: SaveStatus.success, outfitId: '123'),  // Expect success state with outfitId
      ],
    );


    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits [inProgress, failure] when SaveOutfitEvent fails',
      build: () {
        when(() => mockOutfitSaveService.saveOutfitItems(allSelectedItemIds: any(named: 'allSelectedItemIds')))
            .thenThrow(Exception('save error'));
        return bloc;
      },
      seed: () => bloc.state.copyWith(
        selectedItemIds: {
          OutfitItemCategory.clothing: ['1'],
        },
      ),
      act: (bloc) => bloc.add(const SaveOutfitEvent()),
      expect: () => [
        bloc.state.copyWith(saveStatus: SaveStatus.inProgress),
        bloc.state.copyWith(saveStatus: SaveStatus.failure),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, success] when SelectCategoryEvent is successful',
      build: () {
        when(() => mockOutfitFetchService.fetchCreateOutfitItems(any(), any(), any()))
            .thenAnswer((_) async => [
          ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00')),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(const SelectCategoryEvent(OutfitItemCategory.clothing)),
      expect: () => [
        bloc.state.copyWith(
          items: [], // Ensure that the list is empty during the inProgress state
          saveStatus: SaveStatus.inProgress,
        ),
        bloc.state.copyWith(
          items: [
            ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00')),
          ],
          saveStatus: SaveStatus.success,
        ),
      ],
    );

    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, success] when SelectCategoryEvent is successful',
      build: () {
        when(() => mockOutfitFetchService.fetchCreateOutfitItems(any(), any(), any()))
            .thenAnswer((_) async => [
          ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00')),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(const SelectCategoryEvent(OutfitItemCategory.clothing)),
      expect: () => [
        isA<CreateOutfitItemState>()
            .having((state) => state.items, 'items', isEmpty) // Checks that items is empty
            .having((state) => state.saveStatus, 'saveStatus', SaveStatus.inProgress), // Checks the saveStatus
        isA<CreateOutfitItemState>()
            .having((state) => state.items, 'items', [
          ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', amountSpent: 5, itemType: 'clothing', updatedAt: DateTime.parse('2024-08-20 07:20:06.923036+00'))
        ]) // Checks that items contains the expected ClosetItemMinimal
            .having((state) => state.saveStatus, 'saveStatus', SaveStatus.success), // Checks the saveStatus
      ],
    );

  });
}
