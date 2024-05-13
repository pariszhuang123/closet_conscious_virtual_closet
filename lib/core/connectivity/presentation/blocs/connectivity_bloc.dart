import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/connectivity_use_case.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/connectivity_status.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityUseCase _connectivityUseCase;
  StreamSubscription? _connectivitySubscription;

  ConnectivityBloc(this._connectivityUseCase) : super(ConnectivityUnknown()) {
    on<ConnectivityStarted>(_onConnectivityStarted);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  void _onConnectivityStarted(ConnectivityStarted event, Emitter<ConnectivityState> emit) {
    _streamConnectivity(emit);
  }

  void _onCheckConnectivity(CheckConnectivity event, Emitter<ConnectivityState> emit) {
    _streamConnectivity(emit);
  }

  void _streamConnectivity(Emitter<ConnectivityState> emit) {
    _connectivitySubscription?.cancel(); // Cancel existing subscription if any
    _connectivitySubscription = _connectivityUseCase.statusStream.listen(
          (connectivityStatus) {
        if (connectivityStatus == ConnectivityStatus.online) {
          emit(ConnectivityOnline());
        } else {
          emit(ConnectivityOffline());
        }
      },
      onError: (_) => emit(ConnectivityUnknown()),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel(); // Ensure the subscription is cancelled on bloc close
    return super.close();
  }
}
