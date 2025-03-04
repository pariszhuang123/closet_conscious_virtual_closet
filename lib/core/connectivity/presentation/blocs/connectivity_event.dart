part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class ConnectivityChecked extends ConnectivityEvent {
  @override
  List<Object?> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  const ConnectivityChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected]; // Add properties to props for equality
}
