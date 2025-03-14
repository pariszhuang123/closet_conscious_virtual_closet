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

/// This state is emitted when the validation passes.
class EditItemValidationSuccess extends EditItemState {
  final ClosetItemDetailed validatedItem;
  EditItemValidationSuccess({required this.validatedItem});
}

/// This state is emitted when validation fails; inline errors are passed.
class EditItemValidationFailure extends EditItemState {
  final ClosetItemDetailed updatedItem;
  final Map<String, String> validationErrors;

  EditItemValidationFailure({
    required this.updatedItem,
    required this.validationErrors,
  });
}

class EditItemSubmitting extends EditItemState {
  final String itemId;

  EditItemSubmitting({required this.itemId});
}

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
