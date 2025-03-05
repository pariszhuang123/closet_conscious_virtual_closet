part of 'fetch_item_image_cubit.dart';

abstract class FetchItemImageState extends Equatable {
  const FetchItemImageState();

  @override
  List<Object?> get props => [];
}

class FetchItemImageInitial extends FetchItemImageState {}

class FetchItemImageLoading extends FetchItemImageState {}

class FetchItemImageSuccess extends FetchItemImageState {
  final String imageUrl;
  const FetchItemImageSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class FetchItemImageError extends FetchItemImageState {
  final String error;
  const FetchItemImageError(this.error);

  @override
  List<Object?> get props => [error];
}
