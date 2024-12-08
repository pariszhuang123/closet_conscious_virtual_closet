import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/view_multi_closet_bloc.dart';
import 'view_multi_closet_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class ViewMultiClosetProvider extends StatelessWidget {
  final bool isFromMyCloset;

  final CustomLogger logger = CustomLogger('ViewMultiClosetProvider');

  ViewMultiClosetProvider({
    required this.isFromMyCloset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = CoreFetchService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MultiClosetNavigationBloc(
            fetchService: coreFetchService,
          ),
        ),
        BlocProvider(
          create: (_) => ViewMultiClosetBloc(
            fetchService: coreFetchService,
          )..add(FetchViewMultiClosetsEvent()),
        ),
      ],
      child: ViewMultiClosetScreen(
        isFromMyCloset: isFromMyCloset, // Pass to the screen if needed
      ),
    );
  }
}
