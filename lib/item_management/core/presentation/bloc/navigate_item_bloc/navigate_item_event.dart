part of 'navigate_item_bloc.dart';

abstract class NavigateItemEvent extends Equatable {
  const NavigateItemEvent();
}

class FetchDisappearedClosetsEvent extends NavigateItemEvent {

  const FetchDisappearedClosetsEvent();

  @override
  List<Object?> get props => [];
}

