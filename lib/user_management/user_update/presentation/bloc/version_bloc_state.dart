part of 'version_bloc.dart';

abstract class VersionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VersionInitial extends VersionState {}

class VersionChecking extends VersionState {}

class VersionUpdateRequired extends VersionState {}

class VersionValid extends VersionState {}

class VersionError extends VersionState {
  final String error;

  VersionError(this.error);

  @override
  List<Object?> get props => [error];
}
