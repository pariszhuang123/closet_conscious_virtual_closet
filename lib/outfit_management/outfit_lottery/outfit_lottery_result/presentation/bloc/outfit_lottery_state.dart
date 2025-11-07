part of 'outfit_lottery_bloc.dart';

abstract class OutfitLotteryState extends Equatable {
  const OutfitLotteryState();

  @override
  List<Object?> get props => [];
}

class OutfitLotteryInitial extends OutfitLotteryState {}

class OutfitLotteryLoading extends OutfitLotteryState {}

class OutfitLotteryCheckResult extends OutfitLotteryState {
  final bool shouldShow;

  const OutfitLotteryCheckResult(this.shouldShow);

  @override
  List<Object?> get props => [shouldShow];
}

class OutfitLotterySuccess extends OutfitLotteryState {
  final List<ClosetItemMinimal> items;
  final List<String> suggestions;
  final Map<String, dynamic> parameters;

  const OutfitLotterySuccess({
    required this.items,
    this.suggestions = const [],
    required this.parameters,
  });

  List<String> get itemIds => items.map((e) => e.itemId).toList();

  @override
  List<Object?> get props => [items, suggestions, parameters];
}

class OutfitLotteryFailure extends OutfitLotteryState {
  final String message;

  const OutfitLotteryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
