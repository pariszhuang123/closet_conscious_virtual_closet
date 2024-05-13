import 'package:flutter_test/flutter_test.dart';
import 'package:closet_conscious/core/connectivity/data/datasources/network_info.dart';
import 'package:mockito/mockito.dart';

class MockConnectivityStreamController extends Mock implements ConnectivityStreamController {}

void main() {
  late NetworkChecker networkChecker;
  late MockConnectivityStreamController mockStreamController;

  setUp(() {
    mockStreamController = MockConnectivityStreamController();
    networkChecker = NetworkChecker(mockStreamController);  // This should not cause the error if NetworkChecker expects a ConnectivityStreamController
  });

  test('should emit true when internet connection is available', () async {
    // Arrange
    when(mockStreamController.stream).thenAnswer(
            (_) => Stream.value(true)  // Simulating an internet connection available
    );

    // Act and Assert
    final result = await networkChecker.connectivityStream.first;
    expect(result, isTrue);
  });

  test('should emit false when internet connection is not available', () async {
    // Arrange
    when(mockStreamController.stream).thenAnswer(
            (_) => Stream.value(false)  // Simulating no internet connection
    );

    // Act and Assert
    final result = await networkChecker.connectivityStream.first;
    expect(result, isFalse);
  });

  test('should dispose the stream controller when disposed', () {
    // Act
    networkChecker.dispose();

    // Assert
    verify(mockStreamController.dispose()).called(1);  // Verify that dispose was called on the mock
  });
}