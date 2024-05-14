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
  late StreamSubscription<bool> _subscription;

  // Constructor now accepts a ConnectivityStreamController
  NetworkChecker(this._connectivityStreamController) {
    _subscription = _checkInternetConnection();
  }

  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  StreamSubscription<bool> _checkInternetConnection() {
    // Simulating an external class to check internet connection
    return Stream.periodic(const Duration(seconds: 1)).asyncMap((_) async {
      bool hasInternetAccess = await InternetConnection().hasInternetAccess;
      _connectivityStreamController.addConnectivity(hasInternetAccess);
      return hasInternetAccess;
    }).listen((event) {});
  }

  void dispose() {
    _subscription.cancel();
    _connectivityStreamController.dispose();
  }
}
