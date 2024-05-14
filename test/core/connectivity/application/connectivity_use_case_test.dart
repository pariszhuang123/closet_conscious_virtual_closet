import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:closet_conscious/core/connectivity/domain/repositories/connectivity_repository.dart';
import 'package:closet_conscious/core/connectivity/application/connectivity_use_case.dart';
import 'package:closet_conscious/core/connectivity/domain/repositories/connectivity_status.dart';

class MockConnectivityRepository extends Mock implements ConnectivityRepository {}

void main() {
  group('ConnectivityUseCase', () {
    late MockConnectivityRepository mockConnectivityRepository;
    late ConnectivityUseCase connectivityUseCase;

    setUp(() {
      mockConnectivityRepository = MockConnectivityRepository();
      connectivityUseCase = ConnectivityUseCase(mockConnectivityRepository);
    });

    test('should emit online when connectivity is available', () async {
      when(mockConnectivityRepository.connectivityStream).thenAnswer(
              (_) => Stream.value(ConnectivityStatus.online)
      );

      await expectLater(connectivityUseCase.statusStream, emits([
        ConnectivityStatus.online,
      ]));
    });

    test('should emit offline when no connectivity is available', () async {
      // Create a mock stream that emits the expected event
      final mockStream = Stream.value(ConnectivityStatus.offline);

      // Set up the mock repository to return the mock stream
      when(mockConnectivityRepository.connectivityStream).thenAnswer((_) => mockStream);

      // Use expectLater to assert that the statusStream emits the expected event
      await expectLater(connectivityUseCase.statusStream, emits(ConnectivityStatus.offline));
    });

    test('should check initial connectivity status upon initialization', () async {
      // Assuming the use case checks connectivity status immediately upon creation
      when(mockConnectivityRepository.connectivityStream).thenAnswer(
              (_) => Stream.value(ConnectivityStatus.online)
      );

      // Creating the use case should trigger the initial check
      ConnectivityUseCase testUseCase = ConnectivityUseCase(mockConnectivityRepository);

      expectLater(testUseCase.statusStream, emitsInOrder([
        ConnectivityStatus.online,
      ]));
    });

    test('should handle rapid changes in connectivity', () async {
      // Simulate rapid changes from online to offline and back
      when(mockConnectivityRepository.connectivityStream).thenAnswer(
              (_) => Stream.fromIterable([
            ConnectivityStatus.online,
            ConnectivityStatus.offline,
            ConnectivityStatus.online
          ])
      );

      expectLater(connectivityUseCase.statusStream, emitsInOrder([
        ConnectivityStatus.online,
        ConnectivityStatus.offline,
        ConnectivityStatus.online,
      ]));
    });

    test('should handle errors gracefully', () async {
      when(mockConnectivityRepository.connectivityStream).thenAnswer(
              (_) => Stream.error(Exception("Failed to get connectivity."))
      );

      expectLater(connectivityUseCase.statusStream, emitsInOrder([
        emitsError(isInstanceOf<Exception>()),
      ]));
    });
  });
}
