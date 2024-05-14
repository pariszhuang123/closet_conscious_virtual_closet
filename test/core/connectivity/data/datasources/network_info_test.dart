import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:closet_conscious/core/connectivity/data/datasources/network_info.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([ConnectivityStreamController])
void main() {
  late NetworkChecker networkChecker;
  late MockConnectivityStreamController mockStreamController;

  setUp(() {
    mockStreamController = MockConnectivityStreamController();
    networkChecker = NetworkChecker(mockStreamController);
  });

  test('should emit true when internet connection is available', () async {
    final streamController = StreamController<bool>.broadcast();
    when(mockStreamController.stream).thenAnswer((_) => streamController.stream);

    // Manually listen to the stream to debug events
    streamController.stream.listen((event) {
    });

    // Act
    Future.microtask(() => streamController.add(true));

    final result = await networkChecker.connectivityStream.first.timeout(const Duration(seconds: 5));

    // Assert
    expect(result, isTrue);
    await streamController.close();
  });

  test('should emit false when internet connection is not available', () async {
    final streamController = StreamController<bool>.broadcast();
    when(mockStreamController.stream).thenAnswer((_) => streamController.stream);

    // Manually listen to the stream to debug events
    streamController.stream.listen((event) {
    });

    // Act
    Future.microtask(() => streamController.add(false));

    final result = await networkChecker.connectivityStream.first.timeout(const Duration(seconds: 5));

    // Assert
    expect(result, isFalse);
    await streamController.close();
  });

  test('should dispose the stream controller when disposed', () {

    // Act
    networkChecker.dispose();

    // Assert
    verify(mockStreamController.dispose()).called(1);
  });
}
