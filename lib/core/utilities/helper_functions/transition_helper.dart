import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core_enums.dart';

CustomTransitionPage buildCustomTransitionPage({
  required Widget child,
  required TransitionType transitionType,
  required LocalKey key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.slideFromTop:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.slideFadeFromTop:
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation);

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        case TransitionType.slideFromBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.slideFadeFromBottom:
          final slideAnimation = Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation);

          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        case TransitionType.slideFromLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.slideFromRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        case TransitionType.zoomFadeFromCenter:
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.linear,
                reverseCurve: Curves.linear,
              ),
              child: child,
            ),
          );
        case TransitionType.fadeScale:
          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
          final scale = Tween<double>(begin: 0.95, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          );
        case TransitionType.fade:
          return FadeTransition(
            opacity: animation,
            child: child,
          );
      }
    },
  );
}
