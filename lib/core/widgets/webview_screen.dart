import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final bool isFromMyCloset;

  const WebViewScreen({super.key, required this.url, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Theme(
      data: isFromMyCloset ? myClosetTheme : myOutfitTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).infoHub),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
