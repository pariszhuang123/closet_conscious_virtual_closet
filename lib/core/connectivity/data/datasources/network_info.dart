import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// Interface for the StreamController abstraction
abstract class ConnectivityStreamController {
  Stream<bool> get stream;
  void addConnectivity(bool isConnected);
  void dispose();
}

// Concrete implementation of the ConnectivityStreamController
class BroadcastStreamController implements ConnectivityStreamController {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get stream => _controller.stream;

  @override
  void addConnectivity(bool isConnected) {
    _controller.sink.add(isConnected);
  }

  @override
  void dispose() {
    _controller.close();
  }
}

// NetworkChecker class
class NetworkChecker {
  final ConnectivityStreamController _connectivityStreamController;

  // Constructor now accepts a ConnectivityStreamController
  NetworkChecker(this._connectivityStreamController) {
    _checkInternetConnection();
  }

  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  Future<void> _checkInternetConnection() async {
    // Simulating an external class to check internet connection
    bool hasInternetAccess = await InternetConnection().hasInternetAccess; // Ensure this class and method exist and are correct
    _connectivityStreamController.addConnectivity(hasInternetAccess);
  }

  void dispose() {
    _connectivityStreamController.dispose();
  }
}
