import 'package:flutter/material.dart';

import '../../progress_indicator/closet_progress_indicator.dart';

class SafeRedirectScaffold extends StatefulWidget {
  final VoidCallback onRedirect;

  const SafeRedirectScaffold({super.key, required this.onRedirect});

  @override
  State<SafeRedirectScaffold> createState() => _SafeRedirectScaffoldState();
}

class _SafeRedirectScaffoldState extends State<SafeRedirectScaffold> {
  bool hasRedirected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasRedirected && mounted) {
        hasRedirected = true;
        widget.onRedirect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ClosetProgressIndicator(), // <- force visible UI
      ),
    );
  }
}