import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/my_closet_theme.dart';
import '../theme/my_outfit_theme.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool isFromMyCloset;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.isFromMyCloset,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    // Determine the theme based on the isFromMyCloset flag
    final theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
