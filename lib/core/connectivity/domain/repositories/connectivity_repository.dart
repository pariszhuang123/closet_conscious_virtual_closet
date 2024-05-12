import 'dart:async';

enum ConnectivityStatus { online, offline }

abstract class ConnectivityRepository {
  Stream<ConnectivityStatus> get connectivityStream;
}
