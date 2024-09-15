import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(ConnectivityInitial()) {
    _connectivity.onConnectivityChanged.listen((result) async {
      bool hasInternet = await _testInternetConnection();
      add(ConnectivityChanged(hasInternet));
    });

    on<ConnectivityChecked>((event, emit) async {
      bool hasInternet = await _testInternetConnection();
      if (hasInternet) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  Future<bool> _testInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com')).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200; // Internet is working
    } catch (e) {
      return false; // No internet or the request failed
    }
  }
}
