part of 'outfit_lottery_bloc.dart';

abstract class OutfitLotteryEvent {}

class CheckIfShouldShowOutfitLottery extends OutfitLotteryEvent {}

class RunOutfitLottery extends OutfitLotteryEvent {
  final String? occasion;
  final String? season;
  final bool useAllClosets;

  RunOutfitLottery({
    this.occasion,
    this.season,
    this.useAllClosets = false,
  });
}
