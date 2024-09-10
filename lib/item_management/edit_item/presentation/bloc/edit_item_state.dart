part of 'edit_item_bloc.dart';

abstract class EditItemState {}

class EditItemInitial extends EditItemState {}

class EditItemLoading extends EditItemState {}

class EditItemLoaded extends EditItemState {
  final String itemId;
  final ClosetItemDetailed item;

  EditItemLoaded({required this.itemId, required this.item});
}

class EditItemMetadataChanged extends EditItemState {
  final ClosetItemDetailed updatedItem;  // Store the entire updated item

  EditItemMetadataChanged({
    required this.updatedItem,
  });
}

class EditItemNoChanges extends EditItemState {}

class EditItemSubmitting extends EditItemState {
  final String itemId;

  EditItemSubmitting({required this.itemId});
}

class EditItemValidationFailed extends EditItemState {}

class EditItemUpdateSuccess extends EditItemState {

  EditItemUpdateSuccess();
}

class EditItemUpdateFailure extends EditItemState {
  final String errorMessage;

  EditItemUpdateFailure(this.errorMessage);
}

class EditItemLoadFailure extends EditItemState {
  EditItemLoadFailure();
}
