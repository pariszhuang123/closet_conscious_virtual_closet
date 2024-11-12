part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class ProcessPayment extends PaymentEvent {
  final FeatureKey featureKey;
  final bool isIOS; // Pass platform information

  ProcessPayment(this.featureKey, {required this.isIOS});
}

class PaymentPending extends PaymentEvent {}

class PurchaseSuccess extends PaymentEvent {

  PurchaseSuccess();
}

class PurchaseFailure extends PaymentEvent {
  final String errorMessage;

  PurchaseFailure(this.errorMessage);
}
