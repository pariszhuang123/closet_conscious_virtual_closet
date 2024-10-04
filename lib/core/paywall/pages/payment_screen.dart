import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/payment_bloc.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../data/premium_feature_data.dart';
import '../data/feature_key.dart';
import '../../../generated/l10n.dart';
import '../../theme/my_closet_theme.dart';
import '../../theme/my_outfit_theme.dart';
import '../../utilities/logger.dart'; // Import the CustomLogger
import '../../utilities/routes.dart';

class PaymentScreen extends StatefulWidget {
  final FeatureKey featureKey;
  final bool isFromMyCloset;
  final String previousRoute;
  final String nextRoute;
  final String? outfitId;  // Optional outfitId parameter
  final String? itemId;    // Optional itemId parameter

  const PaymentScreen({
    super.key,
    required this.featureKey,
    required this.isFromMyCloset,
    required this.previousRoute,
    required this.nextRoute,
    this.outfitId,   // Optional, can be null
    this.itemId,     // Optional, can be null
  });

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late FeatureData featureData;
  int currentIndex = 0;
  final CustomLogger _logger = CustomLogger('PaymentScreen'); // Initialize CustomLogger

  String? itemId;  // Instance-level variable to store itemId
  String? outfitId;  // Instance-level variable to store outfitId

  @override
  void initState() {
    super.initState();
    // Log initialization
    _logger.i('Initializing PaymentScreen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Moved featureData retrieval to didChangeDependencies because it depends on the context
    featureData = FeatureDataList.features(context).firstWhere((data) => data.featureKey == widget.featureKey);

    // Ensure arguments are properly extracted
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      // Use local variables to store the values from arguments
      _logger.d('Payment screen received arguments: featureKey = ${args['featureKey']}, previousRoute = ${args['previousRoute']}, itemId = ${args['itemId']}');

      // Use arguments as needed (do not modify widget properties directly)
      final itemId = args['itemId'];
      final outfitId = args['outfitId'];

      _logger.d('Received itemId: $itemId and outfitId: $outfitId');


    } else {
      _logger.e('No arguments passed to PaymentScreen.');
    }
  }

  // Cancel Action Handler
  void _onCancel() {
    _logger.i('User cancelled payment, navigating back to ${widget.previousRoute} with itemId: ${widget.itemId}, outfitId: ${widget.outfitId}');

    if (widget.previousRoute == '/edit_item' && widget.itemId != null) {
      _logger.i('Navigating back to EditItem with itemId: ${widget.itemId}');
      Navigator.pop(context, widget.itemId);
    } else if (widget.previousRoute == '/wear_outfit' && widget.outfitId != null) {
      _logger.i('Navigating back to WearOutfit with outfitId: ${widget.outfitId}');
      Navigator.pop(context, widget.outfitId);
    } else if (widget.previousRoute == AppRoutes.myCloset) {
      _logger.i('Navigating back to MyCloset without specific arguments.');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.myCloset, // Default fallback if no previous route matches
      );
    } else if (widget.previousRoute == '/create_outfit') {
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

    return PopScope<Object?>(
      canPop: false, // Preventing back navigation
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          _logger.i('Preventing back navigation');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
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
                        style: appliedTheme.textTheme.titleMedium
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: appliedTheme.colorScheme.onSurface),
                      onPressed: _onCancel,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Carousel for feature images
                SizedBox(
                  height: MediaQuery.of(context).size.height * 1 / 2,
                  child: PageView.builder(
                    itemCount: featureData.parts.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                      _logger.d('Carousel page changed to index $index');
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        featureData.parts[index].imageUrl,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic description based on the image shown in the carousel
                Text(
                  featureData.parts[currentIndex].getDescription(context),
                  style: appliedTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Display price
                Text(
                  "\$${featureData.price.toStringAsFixed(2)}",
                  style: appliedTheme.textTheme.displayLarge?.copyWith(
                    color: appliedTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Themed Elevated Button
                ThemedElevatedButton(
                  text: S.of(context).purchase_button,
                  onPressed: () {
                    _logger.i('Processing payment for featureKey: ${featureData.featureKey.key}');
                    BlocProvider.of<PaymentBloc>(context).add(ProcessPayment(featureData.featureKey.key));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
