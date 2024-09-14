import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:closet_conscious/core/utilities/logger.dart';
import 'package:closet_conscious/item_management/core/data/models/closet_item_minimal.dart';
import 'package:closet_conscious/outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_fetch_service.dart';
import 'package:closet_conscious/outfit_management/core/data/services/outfits_save_service.dart';
import 'package:closet_conscious/outfit_management/create_outfit/presentation/widgets/outfit_grid.dart';
import 'package:closet_conscious/core/photo/presentation/widgets/user_photo/enhanced_user_photo.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:closet_conscious/generated/l10n.dart';

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
  late MockLogger mockLogger;
  late ScrollController scrollController;

  setUp(() {
    mockOutfitFetchService = MockOutfitFetchService();
    mockOutfitSaveService = MockOutfitSaveService();
    mockLogger = MockLogger();
    scrollController = ScrollController();

    bloc = CreateOutfitItemBloc(mockOutfitFetchService, mockOutfitSaveService);

    // Setup the mock state to return a fixed state whenever accessed
    when(() => bloc.state).thenReturn(
      const CreateOutfitItemState(
        saveStatus: SaveStatus.success,
        selectedItemIds: {OutfitItemCategory.clothing: []},
        currentCategory: OutfitItemCategory.clothing,
        currentPage: 0,
        hasReachedMax: false,
      ),
    );
  });

  tearDown(() {
    bloc.close();
  });

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
          value: bloc,
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
    testWidgets('displays noItemsInCategory message when items list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(buildWidgetUnderTest([]));

      expect(find.text('No items found in this category.'), findsOneWidget); // Adjust based on actual localization
    });

    testWidgets('displays failedToLoadItems message when saveStatus is failure', (WidgetTester tester) async {
      when(() => bloc.state).thenReturn(const CreateOutfitItemState(
        saveStatus: SaveStatus.failure,
        selectedItemIds: {},
        currentCategory: OutfitItemCategory.clothing,
        currentPage: 0,  // Required parameter
        hasReachedMax: false,  // Required parameter
      ));

      await tester.pumpWidget(buildWidgetUnderTest([]));

      expect(find.text('Failed to load items.'), findsOneWidget); // Adjust based on actual localization
    });

    testWidgets('displays items in grid when items are loaded', (WidgetTester tester) async {
      final items = [
        ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'Item 1', itemType: 'clothing', amountSpent: 50, updatedAt: DateTime.now()),
        ClosetItemMinimal(itemId: '2', imageUrl: 'url2', name: 'Item 2', itemType: 'clothing', amountSpent: 100, updatedAt: DateTime.now()),
      ];

      await tester.pumpWidget(buildWidgetUnderTest(items));

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(EnhancedUserPhoto), findsNWidgets(2));
    });

    testWidgets('triggers FetchMoreItemsEvent when scrolled to the bottom', (WidgetTester tester) async {
      final items = List.generate(20, (index) => ClosetItemMinimal(
        itemId: index.toString(),
        imageUrl: 'url$index',
        name: 'Item $index',
        itemType: 'clothing',
        amountSpent: 50,
        updatedAt: DateTime.now(),
      ));

      await tester.pumpWidget(buildWidgetUnderTest(items));

      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      await tester.pump();

      verify(() => bloc.add(FetchMoreItemsEvent())).called(1);
    });

    testWidgets('logs correct item count and category on load', (WidgetTester tester) async {
      final items = [
        ClosetItemMinimal(itemId: '1', imageUrl: 'url1', name: 'Item 1', itemType: 'clothing', amountSpent: 50, updatedAt: DateTime.now()),
      ];

      await tester.pumpWidget(buildWidgetUnderTest(items));

      // Wait for everything to settle, especially for localization to be initialized
      await tester.pumpAndSettle();

      // Verify the logger call
      verify(() => mockLogger.d('OutfitGrid: Displaying ${items.length} items for category OutfitItemCategory.clothing')).called(1);
    });
  });
}
