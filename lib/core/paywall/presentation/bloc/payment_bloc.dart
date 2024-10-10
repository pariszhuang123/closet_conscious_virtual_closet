import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../data/services/core_save_services.dart';
import '../../../utilities/logger.dart';
import '../../data/feature_key.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final CoreSaveService _coreSaveService = CoreSaveService();
  final CustomLogger _logger = CustomLogger('PaymentBloc');

  // Store products and purchases
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  PaymentBloc() : super(PaymentInitial()) {
    on<ProcessPayment>(_onProcessPayment);
    on<PurchaseSuccess>(_onPurchaseSuccess);
    on<PurchaseFailure>(_onPurchaseFailure);

    // Initialize IAP
    _initIAP();
  }

  Future<void> _initIAP() async {
    // Listen to purchase updates
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_onPurchaseUpdated, onError: _onPurchaseError);

    // Check availability and fetch products
    await _initStoreInfo();
  }

  Future<void> _initStoreInfo() async {
    _isAvailable = await _inAppPurchase.isAvailable();

    if (!_isAvailable) {
      _logger.e('In-app purchases not available');
      // Handle availability error
      return;
    }

    // Fetch product details
    final Set<String> productIds = FeatureKey.values.map((e) => e.key).toSet();
    final response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.error != null) {
      _logger.e('Product query error: ${response.error}');
      // Handle error
      return;
    }

    if (response.productDetails.isEmpty) {
      _logger.e('No products found');
      // Handle empty product list
      return;
    }

    _products = response.productDetails;
  }

  Future<void> _onProcessPayment(ProcessPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentPendingState());

    try {
      final product = _products.firstWhere(
            (product) => product.id == event.featureKey.key,
        orElse: () => throw Exception('Product not found'),
      );

      _logger.i('Initiating purchase for product ID: ${product.id}');

      final purchaseParam = PurchaseParam(productDetails: product);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      // The purchase updates will be handled in the listener
    } catch (e) {
      _logger.e('Error initiating payment: $e');
      emit(PaymentFailure(e.toString()));
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _logger.i('Purchase update: ${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        add(PaymentPending());
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle failed purchase
        add(PurchaseFailure(purchaseDetails.error?.message ?? 'Unknown error occurred during purchase.'));
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Only handle new purchases, no restoration needed
        _verifyAndDeliverAndroidPurchase(purchaseDetails);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _onPurchaseError(Object error) {
    _logger.e('Purchase stream error: $error');
    add(PurchaseFailure(error.toString()));
  }

  Future<void> _verifyAndDeliverAndroidPurchase(PurchaseDetails purchaseDetails) async {
        // Get the purchaseToken and productId and send them to the Supabase Edge Function
    String purchaseToken = purchaseDetails.verificationData.serverVerificationData;
    String productId = purchaseDetails.productID;

    Sentry.addBreadcrumb(Breadcrumb(
      message: 'Verifying purchase with Supabase Edge function',
      data: {'purchaseToken': purchaseDetails.verificationData.serverVerificationData, 'productId': purchaseDetails.productID},
      level: SentryLevel.info,
    ));

    // Call the method from core_save_services.dart to verify the purchase
    final verificationResult = await _coreSaveService.verifyAndroidPurchaseWithSupabaseEdgeFunction(
      purchaseToken,
      productId,
    );

    if (verificationResult != null && verificationResult['status'] == 'success') {
      _logger.i('Purchase verified and persisted successfully for product: $productId');
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Purchase verified successfully',
        data: {'productId': purchaseDetails.productID},
        level: SentryLevel.info,
      ));
      // Emit a simple success state
      add(PurchaseSuccess());
    } else {
      _logger.e('Invalid purchase: $productId');
      Sentry.captureMessage('Purchase verification failed for product: ${purchaseDetails.productID}', level: SentryLevel.error);
      add(PurchaseFailure('Invalid purchase. Please try again.'));
    }
  }

  Future<void> _onPurchaseSuccess(PurchaseSuccess event, Emitter<PaymentState> emit) async {
    // Simply inform the user that the purchase was successful
    _logger.i('Purchase success.');
    emit(PaymentSuccess());
  }

  void _onPurchaseFailure(PurchaseFailure event, Emitter<PaymentState> emit) {
    emit(PaymentFailure(event.errorMessage));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
