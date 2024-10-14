part of 'upload_item_streak_bloc.dart';

abstract class UploadStreakState extends Equatable {
  const UploadStreakState();

  @override
  List<Object> get props => [];
}

class UploadStreakInitial extends UploadStreakState {}

class UploadStreakLoading extends UploadStreakState {}

class UploadStreakSuccess extends UploadStreakState {
  final bool isUploadCompleted;
  final int apparelCount;
  final int currentStreakCount;
  final int highestStreakCount;
  final int newItemsCost;
  final int newItemsCount;

  const UploadStreakSuccess({
    required this.isUploadCompleted,
    required this.apparelCount,
    required this.currentStreakCount,
    required this.highestStreakCount,
    required this.newItemsCost,
    required this.newItemsCount,
  });

  UploadStreakSuccess copyWith({
    bool? isUploadCompleted,
    int? apparelCount,
    int? currentStreakCount,
    int? highestStreakCount,
    int? newItemsCost,
    int? newItemsCount,
  }) {
    return UploadStreakSuccess(
      isUploadCompleted: isUploadCompleted ?? this.isUploadCompleted,
      apparelCount: apparelCount ?? this.apparelCount,
      currentStreakCount: currentStreakCount ?? this.currentStreakCount,
      highestStreakCount: highestStreakCount ?? this.highestStreakCount,
      newItemsCost: newItemsCost ?? this.newItemsCost,
      newItemsCount: newItemsCount ?? this.newItemsCount,
    );
  }

  @override
  List<Object> get props => [
    isUploadCompleted,
    apparelCount,
    currentStreakCount,
    highestStreakCount,
    newItemsCost,
    newItemsCount,
  ];
}

class UploadStreakFailure extends UploadStreakState {
  final String errorMessage;

  const UploadStreakFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
