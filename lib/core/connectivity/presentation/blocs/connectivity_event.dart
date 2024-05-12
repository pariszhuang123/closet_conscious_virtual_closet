part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityStarted extends ConnectivityEvent {}

// Add new event class for on-demand connectivity checks
class CheckConnectivity extends ConnectivityEvent {}
