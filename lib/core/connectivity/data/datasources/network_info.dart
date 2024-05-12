import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkChecker {
  final StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();


  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  NetworkChecker() {
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool hasInternetAccess = await InternetConnection().hasInternetAccess;
    _connectivityStreamController.sink.add(hasInternetAccess);

  }

  void dispose() {
    _connectivityStreamController.close();
  }
}