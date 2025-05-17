part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class PaymentPendingState extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String errorMessage;

  PaymentFailure(this.errorMessage);
}
