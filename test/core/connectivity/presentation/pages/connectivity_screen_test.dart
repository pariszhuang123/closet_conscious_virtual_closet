import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:closet_conscious/generated/l10n.dart'; // Update with actual path
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this import
import 'package:closet_conscious/core/connectivity/presentation/blocs/connectivity_bloc.dart'; // Update with actual path
import 'package:closet_conscious/core/connectivity/presentation/pages/connectivity_screen.dart';
import 'package:closet_conscious/core/widgets/button/themed_elevated_button.dart';
import 'package:closet_conscious/core/widgets/feedback/custom_snack_bar.dart';
import 'package:closet_conscious/core/theme/my_closet_theme.dart';

// Add this FakeRoute class
class FakeRoute extends Fake implements Route<dynamic> {}

class MockConnectivityBloc extends Mock implements ConnectivityBloc {}
class FakeConnectivityState extends Fake implements ConnectivityState {}
class FakeConnectivityEvent extends Fake implements ConnectivityEvent {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockConnectivityBloc mockConnectivityBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeConnectivityEvent());
    registerFallbackValue(FakeConnectivityState());
    registerFallbackValue(FakeRoute()); // Register FakeRoute here
  });

  setUp(() {
    mockConnectivityBloc = MockConnectivityBloc();
    mockNavigatorObserver = MockNavigatorObserver();

    // Mock the bloc's stream to prevent null errors
    when(() => mockConnectivityBloc.stream).thenAnswer(
          (_) => const Stream<ConnectivityState>.empty(),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh', 'CN'),
      ],
      home: BlocProvider<ConnectivityBloc>.value(
        value: mockConnectivityBloc,
        child: const ConnectivityScreen(),
      ),
      navigatorObservers: [mockNavigatorObserver],
      theme: myClosetTheme, // Provide the theme if necessary
    );
  }

  group('ConnectivityScreen Widget Tests', () {
    testWidgets('displays disconnected UI when state is ConnectivityDisconnected',
            (WidgetTester tester) async {
          // Arrange
          when(() => mockConnectivityBloc.state).thenReturn(ConnectivityDisconnected());
          whenListen(
            mockConnectivityBloc,
            Stream<ConnectivityState>.fromIterable([ConnectivityDisconnected()]),
            initialState: ConnectivityDisconnected(),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Assert
          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.text(S.current.noInternetTitle), findsOneWidget);
          expect(find.byType(SvgPicture), findsOneWidget);
          expect(find.text(S.current.retryConnection), findsOneWidget);
          expect(find.byType(ThemedElevatedButton), findsOneWidget);
        });

    testWidgets('navigates back when state changes to ConnectivityConnected',
            (WidgetTester tester) async {
          // Arrange
          when(() => mockConnectivityBloc.state).thenReturn(ConnectivityDisconnected());
          whenListen(
            mockConnectivityBloc,
            Stream<ConnectivityState>.fromIterable([ConnectivityConnected()]),
            initialState: ConnectivityDisconnected(),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pump(); // Process the state change
          await tester.pumpAndSettle(); // Allow navigation to complete

          // Assert
          verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
          expect(find.byType(ConnectivityScreen), findsNothing);
        });

    testWidgets('dispatches ConnectivityChecked when retry button is tapped',
            (WidgetTester tester) async {
          // Arrange
          when(() => mockConnectivityBloc.state).thenReturn(ConnectivityDisconnected());
          whenListen(
            mockConnectivityBloc,
            Stream<ConnectivityState>.fromIterable([ConnectivityDisconnected()]),
            initialState: ConnectivityDisconnected(),
          );

          // Act
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.tap(find.byType(ThemedElevatedButton));
          await tester.pump(); // Process the tap

          // Assert
          verify(() => mockConnectivityBloc.add(ConnectivityChecked())).called(1);
        });

    testWidgets('shows snackbar when retry is pressed and still disconnected',
            (WidgetTester tester) async {
          // Arrange
          when(() => mockConnectivityBloc.state).thenReturn(ConnectivityDisconnected());

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Tap the retry button
          await tester.tap(find.byType(ThemedElevatedButton));
          await tester.pump(); // Start the onPressed
          await tester.pump(); // Allow state to update

          // Simulate the bloc emitting ConnectivityDisconnected again
          whenListen(
            mockConnectivityBloc,
            Stream<ConnectivityState>.fromIterable([ConnectivityDisconnected()]),
            initialState: ConnectivityDisconnected(),
          );

          await tester.pump(); // Process the new state
          await tester.pump(const Duration(seconds: 1)); // Allow snackbar to appear

          // Assert
          // Instead of finding CustomSnackbar, find the snackbar text
          expect(find.text(S.current.noInternetSnackBar), findsOneWidget);
        });

    testWidgets('does not show snackbar when retry is successful',
            (WidgetTester tester) async {
          // Arrange
          when(() => mockConnectivityBloc.state).thenReturn(ConnectivityDisconnected());

          // Act
          await tester.pumpWidget(createWidgetUnderTest());

          // Tap the retry button
          await tester.tap(find.byType(ThemedElevatedButton));
          await tester.pump(); // Start the onPressed
          await tester.pump(); // Allow state to update

          // Simulate the bloc emitting ConnectivityConnected
          whenListen(
            mockConnectivityBloc,
            Stream<ConnectivityState>.fromIterable([ConnectivityConnected()]),
            initialState: ConnectivityDisconnected(),
          );

          await tester.pump(); // Process the new state
          await tester.pump(const Duration(seconds: 1)); // Allow any animations or state changes

          // Assert
          expect(find.byType(CustomSnackbar), findsNothing);
        });
  });
}
