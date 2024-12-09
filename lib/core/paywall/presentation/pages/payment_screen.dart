import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../presentation/bloc/payment_bloc.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../data/premium_feature_data.dart';
import '../../data/feature_key.dart';
import '../../../../generated/l10n.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/routes.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../presentation/widgets/feature_carousel.dart';


class PaymentScreen extends StatefulWidget {
  final FeatureKey featureKey;
  final bool isFromMyCloset;
  final String previousRoute;
  final String nextRoute;
  final String? outfitId; // Optional outfitId parameter
  final String? itemId;   // Optional itemId parameter

  const PaymentScreen({
    super.key,
    required this.featureKey,
    required this.isFromMyCloset,
    required this.previousRoute,
    required this.nextRoute,
    this.outfitId,  // Optional, can be null
    this.itemId,    // Optional, can be null
  });

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late FeatureData featureData;
  late ProductDetails _productDetails;
  bool _isProductDetailsReady = false;
  int currentIndex = 0;
  final CustomLogger _logger = CustomLogger('PaymentScreen'); // Initialize CustomLogger

  @override
  void initState() {
    super.initState();
    _logger.i('Initializing PaymentScreen');
    _fetchProductDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve featureData based on featureKey
    featureData = FeatureDataList.features(context).firstWhere(
          (data) => data.featureKey == widget.featureKey,
    );

    // Ensure arguments are properly extracted
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _logger.d('Payment screen received arguments: featureKey = ${args['featureKey']}, previousRoute = ${args['previousRoute']}, itemId = ${args['itemId']}');
      // Use arguments as needed
      final itemId = args['itemId'];
      final outfitId = args['outfitId'];
      _logger.d('Received itemId: $itemId and outfitId: $outfitId');
    } else {
      _logger.e('No arguments passed to PaymentScreen.');
    }
  }

  void _fetchProductDetails() async {
    final Set<String> productIds = {widget.featureKey.key}; // Use the SKU from FeatureKey
    final response = await InAppPurchase.instance.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      _logger.e('Product not found for SKU: ${widget.featureKey.key}');
      return;
    }

    if (response.error != null) {
      _logger.e('Error fetching product details: ${response.error}');
      _isProductDetailsReady = true; // Mark product details as ready
      return;
    }

    setState(() {
      _productDetails = response.productDetails.first; // Set the product details
      _isProductDetailsReady = true; // Mark product details as ready
    });
  }

  // Cancel Action Handler
  void _onCancel() {
    _logger.i('User cancelled payment, navigating back to ${widget.previousRoute} with itemId: ${widget.itemId}, outfitId: ${widget.outfitId}');

    if (widget.previousRoute == AppRoutes.editItem && widget.itemId != null) {
      _logger.i('Navigating back to EditItem with itemId: ${widget.itemId}');
      Navigator.pop(context, widget.itemId);
    } else if (widget.previousRoute == AppRoutes.wearOutfit && widget.outfitId != null) {
      _logger.i('Navigating back to WearOutfit with outfitId: ${widget.outfitId}');
      Navigator.pop(context, widget.outfitId);
    } else if (widget.previousRoute == AppRoutes.myCloset) {
      _logger.i('Navigating back to MyCloset without specific arguments.');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.myCloset, // Default fallback if no previous route matches
      );
    } else if (widget.previousRoute == AppRoutes.createOutfit) {
      _logger.i('Navigating back to CreateOutfit without specific arguments.');
      Navigator.pop(context);
    } else {
      // If the previous route is not explicitly handled, use a generic fallback
      _logger.w('Unknown previous route: ${widget.previousRoute}. Navigating to MyCloset as a fallback.');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.myCloset, // Default fallback if no previous route matches
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData appliedTheme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentInProgress) {
          _logger.i('Payment is in progress');
          // Optionally, show a loading indicator or disable UI elements
        } else if (state is PaymentSuccess) {
          _logger.i('Payment successful');
          // Navigate to the next screen or unlock the feature
          Navigator.pushReplacementNamed(context, widget.nextRoute);
        } else if (state is PaymentFailure) {
          _logger.e('Payment failed: ${state.errorMessage}');
          // Show an error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        // Show a loading indicator when payment is in progress
        bool isLoading = state is PaymentInProgress;

        return PopScope<Object?>(
          canPop: false, // Preventing back navigation
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              _logger.i('Preventing back navigation');
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Row for Title and Close Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                featureData.getTitle(context),
                                style: appliedTheme.textTheme.displayLarge,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: appliedTheme.colorScheme.onSurface),
                              onPressed: _onCancel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        FeatureCarousel(
                          imageUrls: featureData.parts.map((part) => part.imageUrl).toList(),
                          descriptions: featureData.parts.map((part) => part.getDescription(context)).toList(),
                          theme: appliedTheme,
                        ),

                        const SizedBox(height: 24),

                        // Display price
                        // Themed Elevated Button
                        ThemedElevatedButton(
                          text: _isProductDetailsReady
                              ? "${S.of(context).purchase_button} ${_productDetails.price}"
                              : S.of(context).loading_text, // Display loading text until _productDetails is available
                          onPressed: isLoading
                              ? null
                              : () {
                            _logger.i('Processing payment for featureKey: ${featureData.featureKey.key}');
                            final isIOS = Platform.isIOS; // Updated platform check
                            _logger.i('Platform check - isIOS: $isIOS');
                            BlocProvider.of<PaymentBloc>(context).add(
                              ProcessPayment(featureData.featureKey, isIOS: isIOS),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Loading indicator
                  if (isLoading)
                    Container(
                      color: appliedTheme.colorScheme.primary, // Theme-based background color
                      child: Center(
                        child: widget.isFromMyCloset
                            ? const ClosetProgressIndicator()
                            : const OutfitProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
