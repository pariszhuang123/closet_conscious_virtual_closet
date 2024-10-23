import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/connectivity_bloc.dart'; // Import the ConnectivityBloc
import 'connectivity_screen.dart';

class ConnectivityProvider extends StatelessWidget {
  final Widget child;

  const ConnectivityProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        // Ensure Directionality is present in the widget tree
        return Directionality(
          textDirection: TextDirection.ltr, // This ensures Directionality for the Stack
          child: Stack(
            children: [
              child, // The app's normal content (e.g., MaterialApp with AuthWrapper)
              if (state is ConnectivityDisconnected)
                const ConnectivityScreen(), // Show ConnectivityScreen if disconnected
            ],
          ),
        );
      },
    );
  }
}
