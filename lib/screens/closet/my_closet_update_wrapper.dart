import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utilities/logger.dart';
import '../../core/utilities/app_router.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';

class MyClosetUpdateWrapper extends StatefulWidget {
  final Widget child;
  const MyClosetUpdateWrapper({required this.child, super.key});

  @override
  State<MyClosetUpdateWrapper> createState() => _MyClosetUpdateWrapperState();
}

class _MyClosetUpdateWrapperState extends State<MyClosetUpdateWrapper> {
  final CustomLogger _logger = CustomLogger('MyClosetUpdateWrapper');
  late final StreamSubscription _closetSub;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _logger.i('Initializing closet update wrapper');

    try {
      _triggerDisappearingClosetPermanent();
    } catch (e, stackTrace) {
      _logger.e('Error during initState');
      _logger.e(e.toString());
      _logger.e(stackTrace.toString());
      setState(() => _ready = true);
    }
  }

  void _triggerDisappearingClosetPermanent() {
    _logger.i('Checking if disappearing closet should return');
    final bloc = context.read<NavigateItemBloc>();
    final router = GoRouter.of(context);

    bloc.add(const FetchDisappearedClosetsEvent());

    _closetSub = bloc.stream.listen((state) {
      if (!mounted) return;

      if (state is FetchDisappearedClosetsSuccessState) {
        _logger.i('Disappearing closet found – navigating to reappearCloset screen');
        router.pushNamed(
          AppRoutesName.reappearCloset,
          extra: {
            'closetId': state.closetId,
            'closetName': state.closetName,
            'closetImage': state.closetImage,
          },
        );
      } else if (state is NavigateItemFailureState) {
        _logger.i('No disappearing closet or idle state – ready to proceed');
        setState(() => _ready = true);
      }
    });
  }

      @override
  void dispose() {
    _logger.i('Disposing wrapper');
    _closetSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ready
        ? widget.child
        : const Scaffold(body: Center(child: ClosetProgressIndicator()));
  }
}
