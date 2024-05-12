import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/connectivity_repository.dart';
import 'package:equatable/equatable.dart';


part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository _connectivityRepository;

  ConnectivityBloc(this._connectivityRepository)
      : super(ConnectivityUnknown()) {
    on<ConnectivityStarted>(_onConnectivityStarted);
    on<CheckConnectivity>(_onCheckConnectivity);  // Handle on-demand connectivity checks
  }

  void _onConnectivityStarted(ConnectivityStarted event, Emitter<ConnectivityState> emit) {
    _streamConnectivity(emit);
  }

  void _onCheckConnectivity(CheckConnectivity event, Emitter<ConnectivityState> emit) {
    _streamConnectivity(emit);
  }

  // Factor out the common streaming functionality
  void _streamConnectivity(Emitter<ConnectivityState> emit) {
    emit.forEach<ConnectivityStatus>(
      _connectivityRepository.connectivityStream,
      onData: (connectivityStatus) {
        return connectivityStatus == ConnectivityStatus.online ? ConnectivityOnline() : ConnectivityOffline();
      },
      onError: (_, __) => ConnectivityUnknown(),
    );
  }
}