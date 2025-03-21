import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:closet_conscious/core/utilities/logger.dart';
import 'package:closet_conscious/core/core_enums.dart';
import 'package:closet_conscious/item_management/core/data/models/closet_item_minimal.dart';
import 'package:closet_conscious/outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import 'package:closet_conscious/outfit_management/core/outfit_enums.dart';
import 'package:closet_conscious/core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';
import 'package:closet_conscious/core/widgets/layout/grid/interactive_item_grid.dart';

// 1. Define Fake Classes for Events and States
class FakeCreateOutfitItemEvent extends Fake implements FetchOutfitItemEvent {}
class FakeCreateOutfitItemState extends Fake implements FetchOutfitItemState {}

// 2. Mock Classes
class MockCreateOutfitItemBloc
    extends MockBloc<FetchOutfitItemEvent, FetchOutfitItemState>
    implements FetchOutfitItemBloc {}

// Mock Logger
class MockLogger extends Mock implements CustomLogger {}

void main() {
  // 3. Register Fallback Values for Events and States
  setUpAll(() {
    registerFallbackValue(FakeCreateOutfitItemEvent());
    registerFallbackValue(FakeCreateOutfitItemState());
  });

  late MockCreateOutfitItemBloc mockBloc;
  late MockLogger mockLogger;
  late ScrollController scrollController;

  setUp(() {
    // Initialize Mock Objects
    mockBloc = MockCreateOutfitItemBloc();
    mockLogger = MockLogger();
    scrollController = ScrollController();

    // Set the initial state of the bloc
    when(() => mockBloc.state).thenReturn(const FetchOutfitItemState(
      saveStatus: SaveStatus.success,
      selectedItemIds: {OutfitItemCategory.clothing: []},
      currentCategory: OutfitItemCategory.clothing,
      categoryItems: {OutfitItemCategory.clothing: []},
      // Initialize with empty list for clothing category
      categoryPages: {OutfitItemCategory.clothing: 0},
      // Start with page 0 for the clothing category
      categoryHasReachedMax: {
        OutfitItemCategory.clothing: false
      }, // False indicating more items can be fetched
    ));

    // Mock the state stream of the bloc
    whenListen(
      mockBloc,
      Stream<FetchOutfitItemState>.fromIterable([
        const FetchOutfitItemState(
          saveStatus: SaveStatus.success,
          selectedItemIds: {OutfitItemCategory.clothing: []},
          currentCategory: OutfitItemCategory.clothing,
          categoryPages: {OutfitItemCategory.clothing: 0},
          // Page 0 for clothing category
          categoryHasReachedMax: {OutfitItemCategory.clothing: false},
          // False indicating more items can be fetched
          categoryItems: {
            OutfitItemCategory.clothing: []
          }, // No items fetched yet
        ),
      ]),
    );

    tearDown(() {
      // Close the bloc and dispose the controller after each test
      mockBloc.close();
      scrollController.dispose();
    });

    // Helper method to build the widgets under test
    Widget buildWidgetUnderTest(List<ClosetItemMinimal> items) {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider<FetchOutfitItemBloc>.value(
            value: mockBloc,
            child: InteractiveItemGrid(
              scrollController: scrollController,
              selectedItemIds: const [],
              itemSelectionMode: ItemSelectionMode.multiSelection,
              isOutfit: false,
              items: items,
              crossAxisCount: 3,
            ),
          ),
        ),
      );
    }

    group('OutfitGrid widgets tests', () {
      testWidgets('displays noItemsInCategory message when items list is empty',
              (WidgetTester tester) async {
            // Stub the bloc state to simulate initial or empty state
            when(() => mockBloc.state).thenReturn(const FetchOutfitItemState(
              saveStatus: SaveStatus.success,
              selectedItemIds: {OutfitItemCategory.clothing: []},
              currentCategory: OutfitItemCategory.clothing,
              categoryPages: {OutfitItemCategory.clothing: 0},
              // Set the page to 0 for clothing
              categoryHasReachedMax: {OutfitItemCategory.clothing: false},
              // No max reached yet
              categoryItems: {
                OutfitItemCategory.clothing: []
              }, // Empty list of items for clothing
            ));

            // Update the listen stream to emit the new state
            whenListen(
              mockBloc,
              Stream<FetchOutfitItemState>.fromIterable([
                const FetchOutfitItemState(
                  saveStatus: SaveStatus.success,
                  selectedItemIds: {OutfitItemCategory.clothing: []},
                  currentCategory: OutfitItemCategory.clothing,
                  categoryPages: {OutfitItemCategory.clothing: 0},
                  // Set the page to 0 for clothing
                  categoryHasReachedMax: {OutfitItemCategory.clothing: false},
                  // No max reached yet
                  categoryItems: {
                    OutfitItemCategory.clothing: []
                  }, // Empty list of items for clothing
                ),
              ]),
            );

            // Build the widgets with an empty items list
            await tester.pumpWidget(buildWidgetUnderTest([]));
            await tester.pump(); // Rebuild the widgets with the new state

            // Access the localized string
            final BuildContext context = tester.element(
                find.byType(InteractiveItemGrid));
            final String expectedNoItemsText = S
                .of(context)
                .noItemsInOutfitCategory;

            // Verify that the no items message is displayed
            expect(find.text(expectedNoItemsText), findsOneWidget);
          });

      testWidgets(
          'displays failedToLoadItems message when saveStatus is failure',
              (WidgetTester tester) async {
            // Stub the bloc state to simulate a failure
            when(() => mockBloc.state).thenReturn(const FetchOutfitItemState(
              saveStatus: SaveStatus.failure,
              selectedItemIds: {},
              currentCategory: OutfitItemCategory.clothing,
              categoryPages: {OutfitItemCategory.clothing: 0},
              // Set page to 0 for clothing
              categoryHasReachedMax: {OutfitItemCategory.clothing: false},
              // No max reached
              categoryItems: {
                OutfitItemCategory.clothing: []
              }, // Empty items for clothing
            ));

            // Update the listen stream to emit the failure state
            whenListen(
              mockBloc,
              Stream<FetchOutfitItemState>.fromIterable([
                const FetchOutfitItemState(
                  saveStatus: SaveStatus.failure,
                  selectedItemIds: {},
                  currentCategory: OutfitItemCategory.clothing,
                  categoryPages: {OutfitItemCategory.clothing: 0},
                  // Set page to 0 for clothing
                  categoryHasReachedMax: {OutfitItemCategory.clothing: false},
                  // No max reached
                  categoryItems: {
                    OutfitItemCategory.clothing: []
                  }, // Empty items for clothing
                ),
              ]),
            );

            // Build the widgets with an empty items list
            await tester.pumpWidget(buildWidgetUnderTest([]));
            await tester.pump(); // Rebuild the widgets with the new state

            // Access the localized string
            final BuildContext context = tester.element(
                find.byType(InteractiveItemGrid));
            final String expectedFailedToLoadText = S
                .of(context)
                .failedToLoadItems;

            // Verify that the failure message is displayed
            expect(find.text(expectedFailedToLoadText), findsOneWidget);
          });

      testWidgets('displays items in grid when items are loaded', (
          WidgetTester tester) async {
        final items = [
          const ClosetItemMinimal(
            itemId: '1',
            imageUrl: 'url1',
            name: 'Item 1',
            itemType: 'clothing',
          ),
          const ClosetItemMinimal(
            itemId: '2',
            imageUrl: 'url2',
            name: 'Item 2',
            itemType: 'clothing',
          ),
        ];

        // Stub the bloc state to simulate loaded items
        when(() => mockBloc.state).thenReturn(FetchOutfitItemState(
          saveStatus: SaveStatus.success,
          selectedItemIds: const {OutfitItemCategory.clothing: []},
          currentCategory: OutfitItemCategory.clothing,
          categoryPages: const {OutfitItemCategory.clothing: 1},
          // Set pages to 1 for clothing
          categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
          // Max not reached yet
          categoryItems: {
            OutfitItemCategory.clothing: items
          }, // Loaded items for clothing category
        ));

        // Update the listen stream to emit the loaded state
        whenListen(
          mockBloc,
          Stream<FetchOutfitItemState>.fromIterable([
            FetchOutfitItemState(
              saveStatus: SaveStatus.success,
              selectedItemIds: const {OutfitItemCategory.clothing: []},
              currentCategory: OutfitItemCategory.clothing,
              categoryPages: const {OutfitItemCategory.clothing: 1},
              // Page 1 for clothing
              categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
              // Max not reached
              categoryItems: {
                OutfitItemCategory.clothing: items
              }, // Loaded items
            ),
          ]),
        );

        // Build the widgets with the loaded items
        await tester.pumpWidget(buildWidgetUnderTest(items));
        await tester.pump(); // Rebuild the widgets with the new state

        // Verify that the GridView and EnhancedUserPhoto widgets are displayed correctly
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(EnhancedUserPhoto), findsNWidgets(2));
      });

      testWidgets('triggers FetchMoreItemsEvent when scrolled to the bottom', (
          WidgetTester tester) async {
        final items = List.generate(
          20,
              (index) =>
              ClosetItemMinimal(
                itemId: index.toString(),
                imageUrl: 'url$index',
                name: 'Item $index',
                itemType: 'clothing',
              ),
        );

        // Stub the bloc state to simulate loaded items
        when(() => mockBloc.state).thenReturn(FetchOutfitItemState(
          saveStatus: SaveStatus.success,
          selectedItemIds: const {OutfitItemCategory.clothing: []},
          currentCategory: OutfitItemCategory.clothing,
          categoryPages: const {OutfitItemCategory.clothing: 1},
          // Set current pages for clothing
          categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
          // Max not reached yet
          categoryItems: {
            OutfitItemCategory.clothing: items
          }, // Loaded items for the category
        ));

        // Update the listen stream to emit the loaded state
        whenListen(
          mockBloc,
          Stream<FetchOutfitItemState>.fromIterable([
            FetchOutfitItemState(
              saveStatus: SaveStatus.success,
              selectedItemIds: const {OutfitItemCategory.clothing: []},
              currentCategory: OutfitItemCategory.clothing,
              categoryPages: const {OutfitItemCategory.clothing: 1},
              // Page 1 for clothing
              categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
              // Max not reached
              categoryItems: {
                OutfitItemCategory.clothing: items
              }, // Loaded items
            ),
          ]),
        );

        // Build the widgets with a large items list to enable scrolling
        await tester.pumpWidget(buildWidgetUnderTest(items));
        await tester.pump(); // Rebuild the widgets with the new state

        // Simulate scrolling to the bottom
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        await tester.pumpAndSettle();

        // Verify that FetchMoreItemsEvent was added at least once
        verify(() => mockBloc.add(FetchMoreItemsEvent())).called(
            greaterThanOrEqualTo(1));
      });

      testWidgets('logs correct item count and category on load', (
          WidgetTester tester) async {
        final items = [
          const ClosetItemMinimal(
            itemId: '1',
            imageUrl: 'url1',
            name: 'Item 1',
            itemType: 'clothing',
          ),
        ];

        // Stub the bloc state to simulate loaded items
        when(() => mockBloc.state).thenReturn(FetchOutfitItemState(
          saveStatus: SaveStatus.success,
          selectedItemIds: const {OutfitItemCategory.clothing: []},
          currentCategory: OutfitItemCategory.clothing,
          categoryPages: const {OutfitItemCategory.clothing: 1},
          // Set current pages for clothing
          categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
          // Max not reached yet
          categoryItems: {
            OutfitItemCategory.clothing: items
          }, // Loaded items for the category
        ));

        // Update the listen stream to emit the loaded state
        whenListen(
          mockBloc,
          Stream<FetchOutfitItemState>.fromIterable([
            FetchOutfitItemState(
              saveStatus: SaveStatus.success,
              selectedItemIds: const {OutfitItemCategory.clothing: []},
              currentCategory: OutfitItemCategory.clothing,
              categoryPages: const {OutfitItemCategory.clothing: 1},
              // Page 1 for clothing
              categoryHasReachedMax: const {OutfitItemCategory.clothing: false},
              // Max not reached
              categoryItems: {
                OutfitItemCategory.clothing: items
              }, // Loaded items
            ),
          ]),
        );

        // Build the widgets with the loaded items
        await tester.pumpWidget(buildWidgetUnderTest(items));
        await tester.pumpAndSettle(); // Rebuild the widgets with the new state

        // Verify that the logger was called at least once
        verify(() =>
            mockLogger.d(
                'OutfitGrid: Displaying ${items
                    .length} items for category OutfitItemCategory.clothing'))
            .called(greaterThanOrEqualTo(1));
      });
    });
  });
}
