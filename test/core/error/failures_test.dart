import 'package:test/test.dart';
import 'package:closet_conscious/core/error/failures.dart';

void main() {
  group('Failure Tests', () {
    // Test ServerFailure
    test('ServerFailure should contain the correct message', () {
      const message = "Server error occurred";
      const failure = ServerFailure(serverMessage: message);

      expect(failure.message, message);
      expect(failure.serverMessage, message);
    });

    // Test CacheFailure
    test('CacheFailure should contain the correct message', () {
      const message = "Cache error occurred";
      const failure = CacheFailure(message: message);

      expect(failure.message, message);
    });

    // Test NetworkFailure
    test('NetworkFailure should contain the correct message', () {
      const message = "Network error occurred";
      const failure = NetworkFailure(message: message);

      expect(failure.message, message);
    });

    // Test AuthenticationFailure
    test('AuthenticationFailure should contain the correct message', () {
      const message = "Authentication error occurred";
      const failure = AuthenticationFailure(message: message);

      expect(failure.message, message);
    });

    // Test PermissionFailure
    test('PermissionFailure should contain the correct message', () {
      const message = "Permission error occurred";
      const failure = PermissionFailure(message: message);

      expect(failure.message, message);
    });

    // Test InvalidInputFailure
    test('InvalidInputFailure should contain the correct message', () {
      const message = "Invalid input error occurred";
      const failure = InvalidInputFailure(message: message);

      expect(failure.message, message);
    });
  });
}
