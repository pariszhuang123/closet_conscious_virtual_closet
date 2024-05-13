import 'dart:async';
import '../domain/repositories/connectivity_repository.dart';
import '../domain/repositories/connectivity_status.dart';

class ConnectivityUseCase {
  final ConnectivityRepository _connectivityRepository;
  StreamSubscription<ConnectivityStatus>? _subscription;

  Stream<ConnectivityStatus> get statusStream => _connectivityRepository.connectivityStream;

  ConnectivityUseCase(this._connectivityRepository) {
    _initialize();
  }

  void _initialize() {
    // No need to listen and add events to a separate controller
  }

  void dispose() {
    _subscription?.cancel(); // Cancel the subscription if it exists
  }
}