import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG logo
import '../../../generated/l10n.dart';
import '../presentation/blocs/connectivity_bloc.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../../widgets/feedback/custom_snack_bar.dart';
import '../../theme/my_closet_theme.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  ConnectivityScreenState createState() => ConnectivityScreenState();
}

class ConnectivityScreenState extends State<ConnectivityScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true); // Logo pulsing animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityConnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
          return Container();
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title above the logo using myClosetTheme text style
                Text(
                  S.of(context).noInternetTitle, // Localized title
                  style: myClosetTheme.textTheme.displayLarge, // Use myClosetTheme's displayMedium for title
                ),
                const SizedBox(height: 20),
                // Animated logo
                ScaleTransition(
                  scale: _controller,
                  child: SvgPicture.asset(
                    'assets/images/SVG_CC_Logo.svg', // Your SVG logo path
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                // Friendly, eco-conscious message using myClosetTheme text style
                Text(
                  S.of(context).noInternetMessage, // Localized message
                  textAlign: TextAlign.center,
                  style: myClosetTheme.textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                // Retry button
                ThemedElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ConnectivityBloc>(context).add(ConnectivityChecked());

                    // Check connection status and show CustomSnackbar if still disconnected
                    if (state is ConnectivityDisconnected) {
                      CustomSnackbar(
                        message: S.of(context).noInternetSnackBar, // Localized snackbar message
                        theme: Theme.of(context), // Use the current theme
                      ).show(context); // Show the custom snackbar
                    }
                  },
                  text: S.of(context).retryConnection, // Localized retry text
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
