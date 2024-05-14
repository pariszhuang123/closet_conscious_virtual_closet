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
    print('Setting up test: should emit true when internet connection is available');
    final streamController = StreamController<bool>.broadcast();
    when(mockStreamController.stream).thenAnswer((_) => streamController.stream);

    // Manually listen to the stream to debug events
    streamController.stream.listen((event) {
      print('Stream event received: $event');
    });

    // Act
    Future.microtask(() => streamController.add(true));
    print('Added true to stream');

    final result = await networkChecker.connectivityStream.first.timeout(const Duration(seconds: 5));
    print('Received result: $result');

    // Assert
    expect(result, isTrue);
    await streamController.close();
  });

  test('should emit false when internet connection is not available', () async {
    print('Setting up test: should emit false when internet connection is not available');
    final streamController = StreamController<bool>.broadcast();
    when(mockStreamController.stream).thenAnswer((_) => streamController.stream);

    // Manually listen to the stream to debug events
    streamController.stream.listen((event) {
      print('Stream event received: $event');
    });

    // Act
    Future.microtask(() => streamController.add(false));
    print('Added false to stream');

    final result = await networkChecker.connectivityStream.first.timeout(const Duration(seconds: 5));
    print('Received result: $result');

    // Assert
    expect(result, isFalse);
    await streamController.close();
  });

  test('should dispose the stream controller when disposed', () {
    print('Setting up test: should dispose the stream controller when disposed');

    // Act
    networkChecker.dispose();
    print('Disposed NetworkChecker');

    // Assert
    verify(mockStreamController.dispose()).called(1);
  });
}
