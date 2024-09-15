part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class ConnectivityChecked extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  ConnectivityChanged(this.isConnected);
}
