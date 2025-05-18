import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utilities/app_router.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../core/utilities/logger.dart';
import '../../core/widgets/progress_indicator/outfit_progress_indicator.dart';

/// Wraps only the "navigate to review" check.
/// If there's an outfitId pending review, we immediately go to the review screen.
class MyOutfitReviewWrapper extends StatefulWidget {
  final Widget child;
  const MyOutfitReviewWrapper({required this.child, super.key});

  @override
  State<MyOutfitReviewWrapper> createState() => _MyOutfitReviewWrapperState();
}

class _MyOutfitReviewWrapperState extends State<MyOutfitReviewWrapper> {
  late final StreamSubscription _sub;
  final CustomLogger _logger = CustomLogger('MyOutfitReviewWrapper');
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _logger.i('Initializing review wrapper');

    try {
      final bloc = context.read<NavigateOutfitBloc>();
      final router = GoRouter.of(context);
      final userId = bloc.authBloc.userId;

      if (userId == null) {
        _logger.w('User ID is null – skipping review check.');
        setState(() => _ready = true);
        return;
      }

      _logger.d('Dispatching CheckNavigationToReviewEvent for userId: $userId');
      bloc.add(CheckNavigationToReviewEvent(userId: userId));

      _sub = bloc.stream.listen((state) {
        if (!mounted) return;

        if (state is NavigateToReviewPageState) {
          _logger.i('Navigating to review screen for outfitId: ${state.outfitId}');
          router.goNamed(
            AppRoutesName.reviewOutfit,
            extra: state.outfitId,
          );
        } else if (state is NoReviewNeededState || state is NavigateOutfitIdleState) {
          // ← Add this fallback state to your NavigateOutfitBloc
          setState(() => _ready = true);
        }
      });
    } catch (e, stackTrace) {
      _logger.e('Error during initState in MyOutfitReviewWrapper');
      _logger.e(e.toString());
      _logger.e(stackTrace.toString());
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _logger.i('Disposing review wrapper and cancelling stream');
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ready
        ? widget.child
        : const Scaffold(
      body: Center(child: OutfitProgressIndicator()),
    );
  }
}
