import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkChecker {
  void Function(bool hasInternet) onConnectionStatusChanged;

  NetworkChecker(this.onConnectionStatusChanged);

  Future<void> checkConnectivity() async {
    List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
    ConnectivityResult connectivityResult = connectivityResults.first;

    if (connectivityResult == ConnectivityResult.none) {
      // No network
      onConnectionStatusChanged(false);
    } else {
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      onConnectionStatusChanged(hasInternet);
    }
  }
}
