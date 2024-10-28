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
      'emits [success (hasReachedMax: false), success (hasReachedMax: true)] when FetchMoreItemsEvent is successful and fewer than 9 items are fetched',
      build: () {
        // Mocking fewer than 9 items to trigger hasReachedMax = true for a specific category
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(
          any(),
          any(),
        )).thenAnswer((_) async => [
          const ClosetItemMinimal(
            itemId: '1',
            imageUrl: 'url1',
            name: 'item1',
            itemType: 'clothing',
          ),
          const ClosetItemMinimal(
            itemId: '2',
            imageUrl: 'url2',
            name: 'item2',
            itemType: 'clothing',
          ),
        ]);

        return bloc;
      },
      act: (bloc) => bloc.add(FetchMoreItemsEvent()),
      expect: () => [
        // First emission: After fetching items
        const CreateOutfitItemState(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          categoryItems: {
            OutfitItemCategory.clothing: [
              ClosetItemMinimal(
                itemId: '1',
                imageUrl: 'url1',
                name: 'item1',
                itemType: 'clothing',
              ),
              ClosetItemMinimal(
                itemId: '2',
                imageUrl: 'url2',
                name: 'item2',
                itemType: 'clothing',
              ),
            ],
          },
          categoryPages: {
            OutfitItemCategory.clothing: 1,
          },
          categoryHasReachedMax: {
            OutfitItemCategory.clothing: false,
          },
          currentCategory: OutfitItemCategory.clothing,
          saveStatus: SaveStatus.success,
          outfitId: null,
          hasSelectedItems: false,
        ),
        // Second emission: After determining that hasReachedMax should be true
        const CreateOutfitItemState(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          categoryItems: {
            OutfitItemCategory.clothing: [
              ClosetItemMinimal(
                itemId: '1',
                imageUrl: 'url1',
                name: 'item1',
                itemType: 'clothing',
              ),
              ClosetItemMinimal(
                itemId: '2',
                imageUrl: 'url2',
                name: 'item2',
                itemType: 'clothing',
              ),
            ],
          },
          categoryPages: {
            OutfitItemCategory.clothing: 1,
          },
          categoryHasReachedMax: {
            OutfitItemCategory.clothing: true,
          },
          currentCategory: OutfitItemCategory.clothing,
          saveStatus: SaveStatus.success,
          outfitId: null,
          hasSelectedItems: false,
        ),
      ],
      verify: (_) {
        verify(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(
          0,
          OutfitItemCategory.clothing,
               )).called(1);
      },
    );


    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, success] when FetchMoreItemsEvent is successful and a full batch of 9 items is fetched',
      build: () {
        // Mock the service to return exactly 9 items
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(any(), any()))
            .thenAnswer((_) async => [
          const ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '2', imageUrl: 'url2', name: 'item2', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '3', imageUrl: 'url3', name: 'item3', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '4', imageUrl: 'url4', name: 'item4', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '5', imageUrl: 'url5', name: 'item5', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '6', imageUrl: 'url6', name: 'item6', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '7', imageUrl: 'url7', name: 'item7', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '8', imageUrl: 'url8', name: 'item8', itemType: 'clothing'),
          const ClosetItemMinimal(itemId: '9', imageUrl: 'url9', name: 'item9', itemType: 'clothing'),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMoreItemsEvent()),
      expect: () => [
        // Expect the state to have 9 items for the given category and hasReachedMax = false
        bloc.state.copyWith(
          categoryItems: {
            OutfitItemCategory.clothing: [
              const ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'item1', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '2', imageUrl: 'url2', name: 'item2', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '3', imageUrl: 'url3', name: 'item3', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '4', imageUrl: 'url4', name: 'item4', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '5', imageUrl: 'url5', name: 'item5', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '6', imageUrl: 'url6', name: 'item6', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '7', imageUrl: 'url7', name: 'item7', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '8', imageUrl: 'url8', name: 'item8', itemType: 'clothing'),
              const ClosetItemMinimal(itemId: '9', imageUrl: 'url9', name: 'item9', itemType: 'clothing'),
            ]
          },
          categoryPages: {OutfitItemCategory.clothing: 1}, // Increment page count for the category
          categoryHasReachedMax: {OutfitItemCategory.clothing: false}, // False because we fetched a full batch
          saveStatus: SaveStatus.success,
        ),
      ],
    );


    blocTest<CreateOutfitItemBloc, CreateOutfitItemState>(
      'emits states [inProgress, failure] when FetchMoreItemsEvent fails',
      build: () {
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(any(), any()))
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
      'emits [inProgress, success] when SelectCategoryEvent is successful',
      build: () {
        // Mock the fetch service to return an item for the specific category
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(
          any(),
          any(),

        )).thenAnswer((_) async => [
          const ClosetItemMinimal(
            itemId: '1',
            imageUrl: 'url1',
            name: 'item1',
            itemType: 'clothing',
          ),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(const SelectCategoryEvent(OutfitItemCategory.clothing)),
      expect: () => [
        // First emission: After initiating category selection (inProgress state)
        const CreateOutfitItemState(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          categoryItems: {
            OutfitItemCategory.clothing: [],
          },
          categoryPages: {
            OutfitItemCategory.clothing: 0,
          },
          categoryHasReachedMax: {
            OutfitItemCategory.clothing: false,
          },
          currentCategory: OutfitItemCategory.clothing,
          saveStatus: SaveStatus.inProgress,
          outfitId: null,
          hasSelectedItems: false,
        ),
        // Second emission: After successfully fetching items (success state)
        const CreateOutfitItemState(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          categoryItems: {
            OutfitItemCategory.clothing: [
              ClosetItemMinimal(
                itemId: '1',
                imageUrl: 'url1',
                name: 'item1',
                itemType: 'clothing',
              ),
            ],
          },
          categoryPages: {
            OutfitItemCategory.clothing: 1,
          },
          categoryHasReachedMax: {
            OutfitItemCategory.clothing: true, // Fewer than 9 items fetched
          },
          currentCategory: OutfitItemCategory.clothing,
          saveStatus: SaveStatus.success,
          outfitId: null,
          hasSelectedItems: false,
        ),
      ],
      verify: (_) {
        verify(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(
          0,
          OutfitItemCategory.clothing,
        )).called(1);
      },
    );

  });
}
