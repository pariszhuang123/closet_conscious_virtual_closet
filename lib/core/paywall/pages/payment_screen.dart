import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/payment_bloc.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../data/premium_feature_data.dart';
import '../data/feature_key.dart';
import '../../../generated/l10n.dart';
import '../../theme/my_closet_theme.dart';
import '../../theme/my_outfit_theme.dart';

class PaymentScreen extends StatefulWidget {
  final FeatureKey featureKey;
  final bool isFromMyCloset;

  const PaymentScreen({super.key, required this.featureKey, required this.isFromMyCloset});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late FeatureData featureData;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Retrieve FeatureData based on featureKey
    featureData = FeatureDataList.features(context).firstWhere((data) => data.featureKey == widget.featureKey);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData appliedTheme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful')));
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed: ${state.error}')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(featureData.getTitle(context)),
          backgroundColor: appliedTheme.colorScheme.primaryContainer,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Carousel for feature images
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: featureData.parts.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      featureData.parts[index].imageUrl,
                      fit: BoxFit.cover,
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
                  BlocProvider.of<PaymentBloc>(context).add(ProcessPayment(featureData.featureKey.key));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
