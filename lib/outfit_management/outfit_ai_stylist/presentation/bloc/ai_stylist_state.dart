part of 'ai_stylist_bloc.dart';

abstract class AiStylistState {}

class AiStylistInitial extends AiStylistState {}

class AiStylistEligibilityChecked extends AiStylistState {
  final bool shouldShow;

  AiStylistEligibilityChecked(this.shouldShow);
}

class AiStylistFailure extends AiStylistState {
  final String message;

  AiStylistFailure(this.message);
}
