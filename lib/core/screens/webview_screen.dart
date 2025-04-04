import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/my_closet_theme.dart';
import '../theme/my_outfit_theme.dart';
import '../../core/utilities/logger.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool isFromMyCloset;
  final String title;

  final CustomLogger logger = CustomLogger('WebViewScreen');

  WebViewScreen({
    super.key,
    required this.url,
    required this.isFromMyCloset,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            logger.i('Page started loading: $url');
          },
          onPageFinished: (url) {
            logger.i('Page finished loading: $url');
          },
          onWebResourceError: (error) {
            logger.e('Web resource error: ${error.description} (Code: ${error.errorCode})');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load page: ${error.description}')),
            );
          },
          onNavigationRequest: (request) {
            logger.d('Navigation request: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
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
