import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n.dart';
import '../presentation/blocs/connectivity_bloc.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../../widgets/feedback/custom_snack_bar.dart';

class ConnectivityScreen extends StatelessWidget {
  const ConnectivityScreen({super.key});

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
          appBar: AppBar(
            title: Text(S.of(context).noInternetTitle), // Localized title
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).noInternetMessage, // Localized message
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
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
                  text: S.of(context).retryConnection, // Localized button text
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
