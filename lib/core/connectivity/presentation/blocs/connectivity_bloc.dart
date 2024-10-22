import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity connectivity;
  final http.Client httpClient;
  late final Stream<List<ConnectivityResult>> _connectivityStream;

  ConnectivityBloc({
    required this.connectivity,
    required this.httpClient,
  }) : super(ConnectivityInitial()) {
    // Adjust the type to handle List<ConnectivityResult>
    _connectivityStream = connectivity.onConnectivityChanged;

    _connectivityStream.listen((resultList) async {
      // You can check the first connectivity result in the list
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
      final response = await httpClient
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200; // Internet is working
    } catch (e) {
      return false; // No internet or the request failed
    }
  }
}
