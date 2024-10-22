import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:closet_conscious/core/connectivity/presentation/blocs/connectivity_bloc.dart'; // Update with your actual import

// Mock Classes
class MockConnectivity extends Mock implements Connectivity {}

class MockHttpClient extends Mock implements http.Client {}

// Fake Classes for Event and State
class FakeConnectivityEvent extends Fake implements ConnectivityEvent {}

class FakeConnectivityState extends Fake implements ConnectivityState {}

void main() {
  late MockConnectivity mockConnectivity;
  late MockHttpClient mockHttpClient;
  late StreamController<List<ConnectivityResult>> connectivityStreamController;  // Update to List<ConnectivityResult>

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(FakeConnectivityEvent());
    registerFallbackValue(FakeConnectivityState());
  });

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockHttpClient = MockHttpClient();
    connectivityStreamController = StreamController<List<ConnectivityResult>>();  // Update to List<ConnectivityResult>

    // Mock the connectivity.onConnectivityChanged stream
    when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => connectivityStreamController.stream,
    );
  });

  tearDown(() {
    connectivityStreamController.close();
  });

  group('ConnectivityBloc', () {
    test('emits ConnectivityInitial as the initial state', () {
      final bloc = ConnectivityBloc(
        connectivity: mockConnectivity,
        httpClient: mockHttpClient,
      );
      expect(bloc.state, ConnectivityInitial());
      bloc.close();
    });

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityConnected] when connectivity changes to connected with internet',
      build: () {
        // Mock internet connection
        when(() => mockHttpClient.get(any())).thenAnswer(
              (_) async => http.Response('OK', 200),
        );
        return ConnectivityBloc(
          connectivity: mockConnectivity,
          httpClient: mockHttpClient,
        );
      },
      act: (bloc) {
        // Simulate connectivity change to WiFi - note that we now add a list
        connectivityStreamController.add([ConnectivityResult.wifi]);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ConnectivityConnected(),
      ],
      verify: (_) {
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityDisconnected] when connectivity changes to none',
      build: () {
        // Mock no internet connection
        when(() => mockHttpClient.get(any())).thenThrow(Exception('No internet'));
        return ConnectivityBloc(
          connectivity: mockConnectivity,
          httpClient: mockHttpClient,
        );
      },
      act: (bloc) {
        // Simulate connectivity change to none - again, note the list
        connectivityStreamController.add([ConnectivityResult.none]);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ConnectivityDisconnected(),
      ],
      verify: (_) {
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityDisconnected, ConnectivityConnected] when connectivity changes to none then back to mobile with internet',
      build: () {
        // First, mock no internet
        when(() => mockHttpClient.get(any())).thenThrow(Exception('No internet'));
        return ConnectivityBloc(
          connectivity: mockConnectivity,
          httpClient: mockHttpClient,
        );
      },
      act: (bloc) async {
        // Simulate connectivity change to none (offline)
        connectivityStreamController.add([ConnectivityResult.none]);
        await Future.delayed(const Duration(milliseconds: 10));

        // Mock internet available
        when(() => mockHttpClient.get(any())).thenAnswer(
              (_) async => http.Response('OK', 200),
        );

        // Simulate connectivity change to mobile with internet
        connectivityStreamController.add([ConnectivityResult.mobile]);
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        ConnectivityDisconnected(),
        ConnectivityConnected(),
      ],
      verify: (_) {
        verify(() => mockHttpClient.get(any())).called(2);
      },
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'handles ConnectivityChecked event by emitting ConnectivityConnected when internet is available',
      build: () {
        when(() => mockHttpClient.get(any())).thenAnswer(
              (_) async => http.Response('OK', 200),
        );
        return ConnectivityBloc(
          connectivity: mockConnectivity,
          httpClient: mockHttpClient,
        );
      },
      act: (bloc) {
        bloc.add(ConnectivityChecked());
      },
      expect: () => [
        ConnectivityConnected(),
      ],
      verify: (_) {
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'handles ConnectivityChecked event by emitting ConnectivityDisconnected when internet is not available',
      build: () {
        when(() => mockHttpClient.get(any())).thenThrow(Exception('No internet'));
        return ConnectivityBloc(
          connectivity: mockConnectivity,
          httpClient: mockHttpClient,
        );
      },
      act: (bloc) {
        bloc.add(ConnectivityChecked());
      },
      expect: () => [
        ConnectivityDisconnected(),
      ],
      verify: (_) {
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );
  });
}
