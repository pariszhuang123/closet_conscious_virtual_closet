import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/core_fetch_services.dart';
import '../../data/services/core_save_services.dart';
import '../presentation/bloc/customize_bloc.dart';
import 'customize_screen.dart';
import '../../../core/utilities/logger.dart'; // Import your logger

class CustomizeProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;

  // Initialize services and logger at the class level
  final CoreFetchService _coreFetchService = CoreFetchService();
  final CoreSaveService _coreSaveService = CoreSaveService();
  final CustomLogger _logger = CustomLogger('CustomizeProvider');

  CustomizeProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
  }) {
    _logger.i('CustomizeProvider initialized with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building CustomizeProvider widget');

    return BlocProvider(
      create: (context) {
        _logger.d('Creating CustomizeBloc with core services');
        final customizeBloc = CustomizeBloc(
          fetchService: _coreFetchService,
          saveService: _coreSaveService,
        );

        _logger.i('Adding LoadCustomizeEvent to CustomizeBloc');
        customizeBloc.add(LoadCustomizeEvent());
        return customizeBloc;
      },
      child: CustomizeScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
