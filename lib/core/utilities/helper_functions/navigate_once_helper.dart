import 'dart:async';
import 'package:flutter/widgets.dart';

mixin NavigateOnceHelper<T extends StatefulWidget> on State<T> {
  bool _hasNavigated = false;

  void navigateOnce(VoidCallback callback) {
    if (_hasNavigated) return;
    _hasNavigated = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      scheduleMicrotask(() {
        callback();
      });
    });
  }

  void resetNavigationFlag() {
    _hasNavigated = false;
  }
}
