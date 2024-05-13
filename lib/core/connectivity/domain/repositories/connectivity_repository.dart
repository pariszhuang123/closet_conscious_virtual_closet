import 'dart:async';
import 'connectivity_status.dart';

abstract class ConnectivityRepository {
  Stream<ConnectivityStatus> get connectivityStream;
}
