part of 'navigate_core_bloc.dart';

abstract class NavigateCoreState extends Equatable {
  const NavigateCoreState();
}

class InitialNavigateCoreState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class ItemAccessGrantedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class BronzeUploadItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class SilverUploadItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class GoldUploadItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class BronzeEditItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class SilverEditItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class GoldEditItemDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class BronzeSelfieDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class SilverSelfieDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class GoldSelfieDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class ClosetAccessGrantedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class BronzeEditClosetDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class SilverEditClosetDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class GoldEditClosetDeniedState extends NavigateCoreState {
  @override
  List<Object?> get props => [];
}

class ItemAccessErrorState extends NavigateCoreState {
  final String errorMessage;

  const ItemAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ClosetAccessErrorState extends NavigateCoreState {
  final String errorMessage;

  const ClosetAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
