import 'dart:async';

abstract class ConnectivityRepository {
  /// Checks the current connectivity status of the device.
  /// Returns `true` if the device is connected to the internet, `false` otherwise.
  Future<bool> checkConnectivity();

  /// Listens to changes in the device's connectivity status.
  /// Returns a stream that emits the current connectivity status whenever it changes.
  Stream<ConnectivityState> listenToConnectivityChanges();
}

enum ConnectivityState {
  online,
  offline,
}