import 'dart:async';
import '../datasources/network_info.dart';
import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl extends ConnectivityRepository {
  final NetworkChecker _networkChecker;

  ConnectivityRepositoryImpl({
    required NetworkChecker networkChecker,
  }) : _networkChecker = networkChecker;

  @override
  Future<bool> checkConnectivity() async {
    bool hasInternetAccess = await _networkChecker.connectivityStream.first;
    return hasInternetAccess;
  }

  @override
  Stream<ConnectivityState> listenToConnectivityChanges() {
    return _networkChecker.connectivityStream.map(_mapConnectivityState);
  }

  ConnectivityState _mapConnectivityState(bool hasInternetAccess) {
    if (hasInternetAccess) {
      return ConnectivityState.online;
    } else {
      return ConnectivityState.offline;
    }
  }

}
