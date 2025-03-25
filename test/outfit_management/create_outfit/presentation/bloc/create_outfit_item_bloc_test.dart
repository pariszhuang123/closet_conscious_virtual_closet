import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:closet_conscious/core/utilities/logger.dart';
import 'package:closet_conscious/core/core_enums.dart';
import 'package:closet_conscious/item_management/core/data/models/closet_item_minimal.dart';
import 'package:closet_conscious/outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_fetch_services.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_save_services.dart';
import 'package:closet_conscious/outfit_management/core/outfit_enums.dart';
import 'package:closet_conscious/core/data/models/image_source.dart';


class MockOutfitFetchService extends Mock implements OutfitFetchService {}

class MockOutfitSaveService extends Mock implements OutfitSaveService {}

class MockLogger extends Mock implements CustomLogger {}

void main() {
  // Register fallback value for OutfitItemCategory
  setUpAll(() {
    registerFallbackValue(OutfitItemCategory.clothing); // or any value from OutfitItemCategory
  });

  late FetchOutfitItemBloc bloc;
  late MockOutfitFetchService mockOutfitFetchService;
  late MockOutfitSaveService mockOutfitSaveService;

  setUp(() {
    mockOutfitFetchService = MockOutfitFetchService();
    mockOutfitSaveService = MockOutfitSaveService();

    bloc = FetchOutfitItemBloc(mockOutfitFetchService, mockOutfitSaveService);
  });

  tearDown(() {
    bloc.close();
  });

  group('CreateOutfitItemBloc', () {
    test('initial state is CreateOutfitItemState.initial()', () {
      expect(bloc.state, FetchOutfitItemState.initial());
    });

    // ✅ Helper function
    List<ClosetItemMinimal> mockNineClothingItems() {
      return List.generate(9, (index) {
        final id = '${index + 1}';
        return ClosetItemMinimal(
          itemId: id,
          imageSource: ImageSource.remote('url$id'),
          name: 'item$id',
          itemType: 'clothing',
        );
      });
    }

    final items = mockNineClothingItems();

    blocTest<FetchOutfitItemBloc, FetchOutfitItemState>(
      'emits states [inProgress, success] when FetchMoreItemsEvent is successful and a full batch of 9 items is fetched',
      build: () {
        // Mock the service to return exactly 9 items
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(any(), any()))
            .thenAnswer((_) async => items);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMoreItemsEvent()),
      expect: () => [
        bloc.state.copyWith(
          categoryItems: {
            OutfitItemCategory.clothing: items
          },
          categoryPages: {OutfitItemCategory.clothing: 1},
          categoryHasReachedMax: {OutfitItemCategory.clothing: false},
          saveStatus: SaveStatus.success,
        ),
      ],
    );



    blocTest<FetchOutfitItemBloc, FetchOutfitItemState>(
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

    blocTest<FetchOutfitItemBloc, FetchOutfitItemState>(
      'emits [inProgress, success] when SelectCategoryEvent is successful',
      build: () {
        // Mock the fetch service to return an item for the specific category
        when(() => mockOutfitFetchService.fetchCreateOutfitItemsRPC(
          any(),
          any(),

        )).thenAnswer((_) async => [
          const ClosetItemMinimal(
            itemId: '1',
            imageSource: ImageSource.remote('url1'),
            name: 'item1',
            itemType: 'clothing',
          ),
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(const SelectCategoryEvent(OutfitItemCategory.clothing)),
      expect: () => [
        // First emission: After initiating category selection (inProgress state)
        const FetchOutfitItemState(
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
        const FetchOutfitItemState(
          selectedItemIds: {
            OutfitItemCategory.clothing: [],
          },
          categoryItems: {
            OutfitItemCategory.clothing: [
              ClosetItemMinimal(
                itemId: '1',
                imageSource: ImageSource.remote('url1'),
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
