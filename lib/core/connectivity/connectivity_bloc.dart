import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(ConnectivityInitial()) {
    // Handle automatic connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      add(ConnectivityResultChanged(result));
    } as void Function(List<ConnectivityResult> event)?);

    // Register event handlers
    on<ConnectivityResultChanged>(_handleConnectivityChange);
    on<CheckConnectivity>(_onCheckConnectivity);
  }

  void _handleConnectivityChange(ConnectivityResultChanged event, Emitter<ConnectivityState> emit) async {
    bool isConnected = await _updateConnectionStatus(event.result);
    if (isConnected) {
      emit(ConnectivityOnline());
    } else {
      emit(ConnectivityOffline());
    }
  }

  void _onCheckConnectivity(CheckConnectivity event, Emitter<ConnectivityState> emit) async {
    var result = await Connectivity().checkConnectivity();
    bool isConnected = await _updateConnectionStatus(result as ConnectivityResult);
    if (isConnected) {
      emit(ConnectivityOnline());
    } else {
      emit(ConnectivityOffline());
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
