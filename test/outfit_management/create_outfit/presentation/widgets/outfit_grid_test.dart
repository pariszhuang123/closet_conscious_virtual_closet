import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:closet_conscious/core/utilities/logger.dart';
import 'package:closet_conscious/item_management/core/data/models/closet_item_minimal.dart';
import 'package:closet_conscious/outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import 'package:closet_conscious/outfit_management/create_outfit/presentation/widgets/outfit_grid.dart';
import 'package:closet_conscious/core/photo/presentation/widgets/user_photo/enhanced_user_photo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';

// 1. Define Fake Classes for Events and States
class FakeCreateOutfitItemEvent extends Fake implements CreateOutfitItemEvent {}
class FakeCreateOutfitItemState extends Fake implements CreateOutfitItemState {}

// 2. Mock Classes
class MockCreateOutfitItemBloc
    extends MockBloc<CreateOutfitItemEvent, CreateOutfitItemState>
    implements CreateOutfitItemBloc {}

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
    when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
      saveStatus: SaveStatus.success,
      selectedItemIds: {OutfitItemCategory.clothing: []},
      currentCategory: OutfitItemCategory.clothing,
      currentPage: 0,
      hasReachedMax: false,
    ));

    // Mock the state stream of the bloc
    whenListen(
      mockBloc,
      Stream<CreateOutfitItemState>.fromIterable([
        const CreateOutfitItemState(
          saveStatus: SaveStatus.success,
          selectedItemIds: {OutfitItemCategory.clothing: []},
          currentCategory: OutfitItemCategory.clothing,
          currentPage: 0,
          hasReachedMax: false,
        ),
      ]),
    );
  });

  tearDown(() {
    // Close the bloc and dispose the controller after each test
    mockBloc.close();
    scrollController.dispose();
  });

  // Helper method to build the widget under test
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
        body: BlocProvider<CreateOutfitItemBloc>.value(
          value: mockBloc,
          child: OutfitGrid(
            scrollController: scrollController,
            logger: mockLogger,
            items: items,
          ),
        ),
      ),
    );
  }

  group('OutfitGrid widget tests', () {
    testWidgets('displays noItemsInCategory message when items list is empty',
            (WidgetTester tester) async {
          // Stub the bloc state to simulate initial or empty state
          when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
            saveStatus: SaveStatus.success,
            selectedItemIds: {OutfitItemCategory.clothing: []},
            currentCategory: OutfitItemCategory.clothing,
            currentPage: 0,
            hasReachedMax: false,
          ));

          // Update the listen stream to emit the new state
          whenListen(
            mockBloc,
            Stream<CreateOutfitItemState>.fromIterable([
              const CreateOutfitItemState(
                saveStatus: SaveStatus.success,
                selectedItemIds: {OutfitItemCategory.clothing: []},
                currentCategory: OutfitItemCategory.clothing,
                currentPage: 0,
                hasReachedMax: false,
              ),
            ]),
          );

          // Build the widget with an empty items list
          await tester.pumpWidget(buildWidgetUnderTest([]));
          await tester.pump(); // Rebuild the widget with the new state

          // Access the localized string
          final BuildContext context = tester.element(find.byType(OutfitGrid));
          final String expectedNoItemsText = S.of(context).noItemsInCategory;

          // Verify that the no items message is displayed
          expect(find.text(expectedNoItemsText), findsOneWidget);
        });

    testWidgets('displays failedToLoadItems message when saveStatus is failure',
            (WidgetTester tester) async {
          // Stub the bloc state to simulate a failure
          when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
            saveStatus: SaveStatus.failure,
            selectedItemIds: {},
            currentCategory: OutfitItemCategory.clothing,
            currentPage: 0,
            hasReachedMax: false,
          ));

          // Update the listen stream to emit the failure state
          whenListen(
            mockBloc,
            Stream<CreateOutfitItemState>.fromIterable([
              const CreateOutfitItemState(
                saveStatus: SaveStatus.failure,
                selectedItemIds: {},
                currentCategory: OutfitItemCategory.clothing,
                currentPage: 0,
                hasReachedMax: false,
              ),
            ]),
          );

          // Build the widget with an empty items list
          await tester.pumpWidget(buildWidgetUnderTest([]));
          await tester.pump(); // Rebuild the widget with the new state

          // Access the localized string
          final BuildContext context = tester.element(find.byType(OutfitGrid));
          final String expectedFailedToLoadText = S.of(context).failedToLoadItems;

          // Verify that the failure message is displayed
          expect(find.text(expectedFailedToLoadText), findsOneWidget);
        });

    testWidgets('displays items in grid when items are loaded',
            (WidgetTester tester) async {
          final items = [
            ClosetItemMinimal(
              itemId: '1',
              imageUrl: 'url1',
              name: 'Item 1',
              itemType: 'clothing',
              amountSpent: 50,
              updatedAt: DateTime.now(),
            ),
            ClosetItemMinimal(
              itemId: '2',
              imageUrl: 'url2',
              name: 'Item 2',
              itemType: 'clothing',
              amountSpent: 100,
              updatedAt: DateTime.now(),
            ),
          ];

          // Stub the bloc state to simulate loaded items
          when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
            saveStatus: SaveStatus.success,
            selectedItemIds: {OutfitItemCategory.clothing: []},
            currentCategory: OutfitItemCategory.clothing,
            currentPage: 1,
            hasReachedMax: false,
          ));

          // Update the listen stream to emit the loaded state
          whenListen(
            mockBloc,
            Stream<CreateOutfitItemState>.fromIterable([
              const CreateOutfitItemState(
                saveStatus: SaveStatus.success,
                selectedItemIds: {OutfitItemCategory.clothing: []},
                currentCategory: OutfitItemCategory.clothing,
                currentPage: 1,
                hasReachedMax: false,
              ),
            ]),
          );

          // Build the widget with the loaded items
          await tester.pumpWidget(buildWidgetUnderTest(items));
          await tester.pump(); // Rebuild the widget with the new state

          // Verify that the GridView and EnhancedUserPhoto widgets are displayed correctly
          expect(find.byType(GridView), findsOneWidget);
          expect(find.byType(EnhancedUserPhoto), findsNWidgets(2));
        });

    testWidgets('triggers FetchMoreItemsEvent when scrolled to the bottom',
            (WidgetTester tester) async {
          final items = List.generate(
            20,
                (index) => ClosetItemMinimal(
              itemId: index.toString(),
              imageUrl: 'url$index',
              name: 'Item $index',
              itemType: 'clothing',
              amountSpent: 50,
              updatedAt: DateTime.now(),
            ),
          );

          // Stub the bloc state to simulate loaded items
          when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
            saveStatus: SaveStatus.success,
            selectedItemIds: {OutfitItemCategory.clothing: []},
            currentCategory: OutfitItemCategory.clothing,
            currentPage: 1,
            hasReachedMax: false,
          ));

          // Update the listen stream to emit the loaded state
          whenListen(
            mockBloc,
            Stream<CreateOutfitItemState>.fromIterable([
              const CreateOutfitItemState(
                saveStatus: SaveStatus.success,
                selectedItemIds: {OutfitItemCategory.clothing: []},
                currentCategory: OutfitItemCategory.clothing,
                currentPage: 1,
                hasReachedMax: false,
              ),
            ]),
          );

          // Build the widget with a large items list to enable scrolling
          await tester.pumpWidget(buildWidgetUnderTest(items));
          await tester.pump(); // Rebuild the widget with the new state

          // Simulate scrolling to the bottom
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
          await tester.pumpAndSettle();

          // Verify that FetchMoreItemsEvent was added at least once
          verify(() => mockBloc.add(FetchMoreItemsEvent())).called(greaterThanOrEqualTo(1));
        });

    testWidgets('logs correct item count and category on load',
            (WidgetTester tester) async {
          final items = [
            ClosetItemMinimal(
              itemId: '1',
              imageUrl: 'url1',
              name: 'Item 1',
              itemType: 'clothing',
              amountSpent: 50,
              updatedAt: DateTime.now(),
            ),
          ];

          // Stub the bloc state to simulate loaded items
          when(() => mockBloc.state).thenReturn(const CreateOutfitItemState(
            saveStatus: SaveStatus.success,
            selectedItemIds: {OutfitItemCategory.clothing: []},
            currentCategory: OutfitItemCategory.clothing,
            currentPage: 1,
            hasReachedMax: false,
          ));

          // Update the listen stream to emit the loaded state
          whenListen(
            mockBloc,
            Stream<CreateOutfitItemState>.fromIterable([
              const CreateOutfitItemState(
                saveStatus: SaveStatus.success,
                selectedItemIds: {OutfitItemCategory.clothing: []},
                currentCategory: OutfitItemCategory.clothing,
                currentPage: 1,
                hasReachedMax: false,
              ),
            ]),
          );

          // Build the widget with the loaded items
          await tester.pumpWidget(buildWidgetUnderTest(items));
          await tester.pumpAndSettle(); // Rebuild the widget with the new state

          // Verify that the logger was called at least once
          verify(() => mockLogger.d(
              'OutfitGrid: Displaying ${items.length} items for category OutfitItemCategory.clothing')).called(greaterThanOrEqualTo(1));
        });
  });
}
