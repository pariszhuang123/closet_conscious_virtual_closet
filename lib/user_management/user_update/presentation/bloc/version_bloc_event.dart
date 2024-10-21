part of 'version_bloc.dart';

abstract class VersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckVersionEvent extends VersionEvent {}
