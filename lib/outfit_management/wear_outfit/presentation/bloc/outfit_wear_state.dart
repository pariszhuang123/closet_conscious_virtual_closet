part of 'outfit_wear_bloc.dart';

abstract class OutfitWearState extends Equatable {
  const OutfitWearState();

  @override
  List<Object?> get props => [];
}

class OutfitWearInitial extends OutfitWearState {}

class OutfitWearLoading extends OutfitWearState {}

class OutfitWearLoaded extends OutfitWearState {
  final List<ClosetItemMinimal> items;  // Assuming OutfitItem is your model class

  const OutfitWearLoaded(
      this.items);

  @override
  List<Object?> get props => [items];
}

class SelfieTaken extends OutfitWearState {
  final List<ClosetItemMinimal> items; // Updated list with the selfie at the top
  const SelfieTaken(this.items);

  @override
  List<Object?> get props => [items];
}

class ShareSuccessful extends OutfitWearState {}

class OutfitWearError extends OutfitWearState {
  final String message;
  const OutfitWearError(this.message);

  @override
  List<Object?> get props => [message];
}

class OutfitImageUrlAvailable extends OutfitWearState {
  final String imageUrl;

  const OutfitImageUrlAvailable(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class OutfitWearSubmitting extends OutfitWearState {}

class OutfitCreationSuccess extends OutfitWearState {}
