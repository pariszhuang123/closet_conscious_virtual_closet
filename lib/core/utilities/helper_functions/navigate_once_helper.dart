import 'dart:async';
import 'package:flutter/widgets.dart';

mixin NavigateOnceHelper<T extends StatefulWidget> on State<T> {
  bool _hasNavigated = false;

  void navigateOnce(VoidCallback callback) {
    if (_hasNavigated) return;

    _hasNavigated = true;

    // Use microtask to delay until it's safe to navigate
    scheduleMicrotask(() {
      if (mounted) {
        callback();
      }
    });
  }

  void resetNavigationFlag() {
    _hasNavigated = false;
  }
}
