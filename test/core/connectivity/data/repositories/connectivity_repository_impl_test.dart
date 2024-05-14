import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:closet_conscious/core/connectivity/data/datasources/network_info.dart';
import 'package:closet_conscious/core/connectivity/domain/repositories/connectivity_status.dart';
import 'package:closet_conscious/core/connectivity/data/repositories/connectivity_repository_impl.dart';

import 'connectivity_repository_impl_test.mocks.dart';

@GenerateMocks([NetworkChecker])  // Annotate the class to generate the mock

void main() {
  group('ConnectivityRepositoryImpl', () {
    late MockNetworkChecker mockNetworkChecker;
    late ConnectivityRepositoryImpl connectivityRepository;

    setUp(() {
      mockNetworkChecker = MockNetworkChecker();
      connectivityRepository = ConnectivityRepositoryImpl(mockNetworkChecker);
    });

    test('should emit ConnectivityStatus.online when internet connection is available', () async {
      // Arrange
      when(mockNetworkChecker.connectivityStream).thenAnswer(
              (_) => Stream.value(true)  // Simulating an internet connection available
      );

      // Act and Assert
      expect(
          connectivityRepository.connectivityStream,
          emitsInOrder([ConnectivityStatus.online])  // Expects the mapped status
      );
    });

    test('should emit ConnectivityStatus.offline when internet connection is not available', () async {
      // Arrange
      when(mockNetworkChecker.connectivityStream).thenAnswer(
              (_) => Stream.value(false)  // Simulating no internet connection
      );

      // Act and Assert
      expect(
          connectivityRepository.connectivityStream,
          emitsInOrder([ConnectivityStatus.offline])  // Expects the mapped status
      );
    });
  });
}
