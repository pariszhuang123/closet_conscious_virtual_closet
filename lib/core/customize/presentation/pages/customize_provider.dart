import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Import GetIt

import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../presentation/bloc/customize_bloc.dart';
import 'customize_screen.dart';
import '../../../utilities/logger.dart'; // Import your logger
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';

class CustomizeProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final String returnRoute;

  // Initialize logger at the class level
  final CustomLogger _logger = CustomLogger('CustomizeProvider');

  CustomizeProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.returnRoute,
  }) {
    _logger.i('CustomizeProvider initialized with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building CustomizeProvider widgets');

    // Fetch services from GetIt inside the build method
    final coreFetchService = GetIt.instance.get<CoreFetchService>();
    final coreSaveService = GetIt.instance.get<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomizeBloc>(
          create: (context) {
            _logger.d('Creating CustomizeBloc with core services');
            final bloc = CustomizeBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
            _logger.i('Adding LoadCustomizeEvent to CustomizeBloc');
            return bloc;
          },
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            _logger.d('Creating TutorialBloc with core services');
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
      ],
      child: CustomizeScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds,
        returnRoute: returnRoute,
      ),
    );
  }
}
