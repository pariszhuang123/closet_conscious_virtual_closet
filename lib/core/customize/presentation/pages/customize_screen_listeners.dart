import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/logger.dart';
import '../../../core_enums.dart';
import '../../presentation/bloc/customize_bloc.dart';
import '../../../utilities/helper_functions/navigate_once_helper.dart';

class CustomizeScreenListeners extends StatefulWidget {
  final bool isFromMyCloset;
  final String returnRoute;
  final List<String> selectedItemIds;
  final CustomLogger logger;
  final Widget child;

  const CustomizeScreenListeners({
    super.key,
    required this.isFromMyCloset,
    required this.returnRoute,
    required this.selectedItemIds,
    required this.logger,
    required this.child,
  });

  @override
  State<CustomizeScreenListeners> createState() => _CustomizeScreenListenersState();
}

class _CustomizeScreenListenersState extends State<CustomizeScreenListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomizeBloc, CustomizeState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              widget.logger.i('Customization saved, navigating back to ${widget.returnRoute}');
              navigateOnce(() {
                context.goNamed(
                  widget.returnRoute,
                  extra: {'selectedItemIds': widget.selectedItemIds},
                );
              });
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
