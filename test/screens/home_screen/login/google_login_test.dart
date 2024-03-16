import 'package:closet_conscious/main.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../test_setup.dart'; // Adjust the import path based on your directory structure
import 'package:flutter/material.dart';

void main() {
  setUp(() {
    setupGoogleSignInMocks();  // Prepare mock responses for Google Sign-In
  });

  testWidgets('Google login/signup button shows correctly', (WidgetTester tester) async {
    // Load your app in the test environment
    await tester.pumpWidget(MyCustomApp());
    // Check if the Google login/signup button is present
    expect(find.byKey(const Key('loginWithGoogle')), findsOneWidget);
  });

  testWidgets('Successful Google login redirects to HomeScreen', (WidgetTester tester) async {
    // Setup a successful login response
    setupSuccessfulLogin();  // Make sure you define this in your test setup to mock a successful Google login

    await tester.pumpWidget(MyCustomApp());
    await tester.tap(find.byKey(const Key('loginWithGoogle'))); // Simulate button tap
    await tester.pumpAndSettle(); // Wait for all animations and callbacks

    // Assuming successful login redirects to HomeScreen, replace 'HomeScreen' with your actual home screen widget
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Google login fails shows error message', (WidgetTester tester) async {
    // Setup a failed login response
    setupFailedLogin();  // Define this in your test setup to mock a failed Google login

    await tester.pumpWidget(MyCustomApp());
    await tester.tap(find.byKey(const Key('loginWithGoogle')));
    await tester.pump(); // Pump once to trigger the button tap action

    // You may want to check for an error message, depending on how your app handles login failures
    // This assumes your app shows a FlutterToast message upon failure
    expect(find.text('Login failed'), findsOneWidget);  // Replace 'Login failed' with your actual error message
  });

  testWidgets('User cancels Google login process', (WidgetTester tester) async {
    // Setup a user cancellation response
    setupUserCancellation();  // Define this to simulate user cancelling the Google login process

    await tester.pumpWidget(MyCustomApp());
    await tester.tap(find.byKey(const Key('loginWithGoogle')));
    await tester.pump(); // Pump once to trigger the button tap action

    // Verify the user remains on the login screen or sees a cancellation message, depending on your app's behavior
    // This is just an example; replace or remove depending on your app's logic
    expect(find.byType(Logincreen), findsOneWidget);
  });

  // More tests can be added here for different scenarios
}
