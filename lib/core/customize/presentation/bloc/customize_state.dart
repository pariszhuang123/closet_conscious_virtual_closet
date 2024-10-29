part of 'customize_bloc.dart';

class CustomizeState extends Equatable {
  final int gridSize;
  final String sortCategory;
  final String sortOrder;
  final SaveStatus saveStatus;

  const CustomizeState({
    required this.gridSize,
    required this.sortCategory,
    required this.sortOrder,
    required this.saveStatus,
  });

  CustomizeState copyWith({
    int? gridSize,
    String? sortCategory,
    String? sortOrder,
    SaveStatus? saveStatus,
  }) {
    return CustomizeState(
      gridSize: gridSize ?? this.gridSize,
      sortCategory: sortCategory ?? this.sortCategory,
      sortOrder: sortOrder ?? this.sortOrder,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  List<Object?> get props => [gridSize, sortCategory, sortOrder, saveStatus];
}
