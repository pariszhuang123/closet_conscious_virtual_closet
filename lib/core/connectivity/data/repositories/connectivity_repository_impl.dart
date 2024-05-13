import 'dart:async';

import '../datasources/network_info.dart';  // Ensure this contains a correct implementation of NetworkChecker with a connectivityStream
import '../../domain/repositories/connectivity_repository.dart';
import '../../domain/repositories/connectivity_status.dart';


class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final NetworkChecker _networkChecker;

  ConnectivityRepositoryImpl(this._networkChecker);

  @override
  Stream<ConnectivityStatus> get connectivityStream =>
      _networkChecker.connectivityStream.map((hasInternet) {
        return hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline;
      });
}
