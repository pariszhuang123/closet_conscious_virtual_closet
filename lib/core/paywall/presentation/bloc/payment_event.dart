part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class ProcessPayment extends PaymentEvent {
  final String featureKey;

  ProcessPayment(this.featureKey);
}
