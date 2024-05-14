import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:closet_conscious/core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'package:closet_conscious/core/connectivity/domain/repositories/connectivity_status.dart';
import 'package:closet_conscious/core/connectivity/application/connectivity_use_case.dart';

import 'connectivity_bloc_test.mocks.dart'; // Import the generated mocks file

@GenerateMocks([ConnectivityUseCase]) // Annotate the class to generate the mock
void main() {
  group('ConnectivityBloc', () {
    late MockConnectivityUseCase mockConnectivityUseCase;
    late ConnectivityBloc connectivityBloc;

    setUp(() {
      mockConnectivityUseCase = MockConnectivityUseCase();
      connectivityBloc = ConnectivityBloc(mockConnectivityUseCase);
    });

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityOnline] when use case reports online status',
      build: () {
        when(mockConnectivityUseCase.statusStream).thenAnswer(
                (_) => Stream.value(ConnectivityStatus.online)
        );
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(ConnectivityStarted()),
      expect: () => [ConnectivityOnline()],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityOffline] when use case reports offline status',
      build: () {
        when(mockConnectivityUseCase.statusStream).thenAnswer(
                (_) => Stream.value(ConnectivityStatus.offline)
        );
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(ConnectivityStarted()),
      expect: () => [ConnectivityOffline()],
    );

    blocTest<ConnectivityBloc, ConnectivityState>(
      'emits [ConnectivityUnknown] on stream error',
      build: () {
        when(mockConnectivityUseCase.statusStream).thenAnswer(
                (_) => Stream.error('Error')
        );
        return connectivityBloc;
      },
      act: (bloc) => bloc.add(ConnectivityStarted()),
      expect: () => [ConnectivityUnknown()],
    );

    tearDown(() {
      connectivityBloc.close();
    });
  });
}
