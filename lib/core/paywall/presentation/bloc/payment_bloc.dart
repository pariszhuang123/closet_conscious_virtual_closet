import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<ProcessPayment>(_onProcessPayment);
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentInProgress());

    try {
      // Simulate the payment process
      await initiatePayment(event.featureKey);
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> initiatePayment(String featureKey) async {
    // Simulated payment logic
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful payment
    return;
  }
}
