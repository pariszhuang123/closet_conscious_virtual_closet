part of 'outfit_focused_date_cubit.dart';

abstract class OutfitFocusedDateState {}

class OutfitFocusedDateInitial extends OutfitFocusedDateState {}

class OutfitFocusedDateLoading extends OutfitFocusedDateState {}

class OutfitFocusedDateSuccess extends OutfitFocusedDateState {
  final String outfitId;
  OutfitFocusedDateSuccess(this.outfitId);
}

class OutfitFocusedDateFailure extends OutfitFocusedDateState {
  final String error;
  OutfitFocusedDateFailure(this.error);
}
