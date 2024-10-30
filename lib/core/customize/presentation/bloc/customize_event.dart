part of 'customize_bloc.dart';

abstract class CustomizeEvent extends Equatable {
  const CustomizeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomizeEvent extends CustomizeEvent {}

class UpdateCustomizeEvent extends CustomizeEvent {
  final int? gridSize;
  final String? sortCategory;
  final String? sortOrder;

  const UpdateCustomizeEvent({
    this.gridSize,
    this.sortCategory,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [gridSize, sortCategory, sortOrder];
}

class SaveCustomizeEvent extends CustomizeEvent {}

class ResetCustomizeEvent extends CustomizeEvent {}

class CheckCustomizeAccessEvent extends CustomizeEvent {}

