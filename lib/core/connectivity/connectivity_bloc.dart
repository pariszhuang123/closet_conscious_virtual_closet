import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(ConnectivityInitial()) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // Directly calling a function to handle the connectivity change
      _handleConnectivityChange(result);
    } as void Function(List<ConnectivityResult> event)?);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    // Convert the connectivity result into a more usable boolean for connected status
    add(ConnectivityResultChanged(result));
  }

  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is ConnectivityResultChanged) {
      bool isConnected = await _updateConnectionStatus(event.result);
      if (isConnected) {
        yield ConnectivityOnline();
      } else {
        yield ConnectivityOffline();
      }
    }
  }

  Future<bool> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false; // Not connected to any network
    } else {
      // Check if there is actual internet access
      return await InternetConnectionChecker().hasConnection;
    }
  }
}