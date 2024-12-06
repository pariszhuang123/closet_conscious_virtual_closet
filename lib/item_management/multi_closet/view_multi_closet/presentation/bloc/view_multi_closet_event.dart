part of 'view_multi_closet_bloc.dart';

abstract class ViewMultiClosetEvent extends Equatable{
  const ViewMultiClosetEvent();

  @override
  List<Object?> get props => [];
}

class FetchViewMultiClosetsEvent extends ViewMultiClosetEvent {}