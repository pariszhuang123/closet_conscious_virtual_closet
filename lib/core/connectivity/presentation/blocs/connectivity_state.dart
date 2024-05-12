part of 'connectivity_bloc.dart';

// Base class
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

// State variants
class ConnectivityOnline extends ConnectivityState {}

class ConnectivityOffline extends ConnectivityState {}

class ConnectivityUnknown extends ConnectivityState {}
