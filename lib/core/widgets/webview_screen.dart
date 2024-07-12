import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../generated/l10n.dart';


class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).infoHub),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
