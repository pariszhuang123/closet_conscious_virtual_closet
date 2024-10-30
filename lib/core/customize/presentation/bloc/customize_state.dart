part of 'customize_bloc.dart';

class CustomizeState extends Equatable {
  final int gridSize;
  final String sortCategory;
  final String sortOrder;
  final SaveStatus saveStatus;
  final AccessStatus accessStatus;

  const CustomizeState({
    required this.gridSize,
    required this.sortCategory,
    required this.sortOrder,
    required this.saveStatus,
    this.accessStatus = AccessStatus.pending, // Default to unknown
  });

  CustomizeState copyWith({
    int? gridSize,
    String? sortCategory,
    String? sortOrder,
    SaveStatus? saveStatus,
    AccessStatus? accessStatus,
  }) {
    return CustomizeState(
      gridSize: gridSize ?? this.gridSize,
      sortCategory: sortCategory ?? this.sortCategory,
      sortOrder: sortOrder ?? this.sortOrder,
      saveStatus: saveStatus ?? this.saveStatus,
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object?> get props => [gridSize, sortCategory, sortOrder, saveStatus, accessStatus];
}
