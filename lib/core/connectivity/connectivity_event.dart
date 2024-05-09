part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class ConnectivityResultChanged extends ConnectivityEvent {
  final ConnectivityResult result;
  ConnectivityResultChanged(this.result);
}