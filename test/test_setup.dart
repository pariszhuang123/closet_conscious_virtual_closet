import 'package:mockito/mockito.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Define your mock classes
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

// Global variables for mocks, so they can be accessed in tests
final MockGoogleSignIn mockGoogleSignIn = MockGoogleSignIn();
final MockGoogleSignInAccount mockGoogleSignInAccount = MockGoogleSignInAccount();
final MockGoogleSignInAuthentication mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

void setupGoogleSignInMocks() {
  // Configure common mock behaviors
  when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
  when(mockGoogleSignInAccount.authentication).thenAnswer((_) async => mockGoogleSignInAuthentication);
  // Set up other default mock behaviors here.
}
