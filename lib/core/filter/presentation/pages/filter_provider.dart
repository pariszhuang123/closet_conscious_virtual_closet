import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../presentation/bloc/filter_bloc.dart';
import 'filter_screen.dart';
import '../../../../core/utilities/logger.dart'; // Import your logger

class FilterProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds; // Add this line

  // Initialize services and logger at the class level
  final CoreFetchService _coreFetchService = CoreFetchService();
  final CoreSaveService _coreSaveService = CoreSaveService();
  final CustomLogger _logger = CustomLogger('FilterProvider');

  FilterProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds, // Add this line
  }) {
    _logger.i('FilterProvider initialized with isFromMyCloset: $isFromMyCloset and selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building FilterProvider widgets');

    return BlocProvider(
      create: (context) {
        _logger.d('Creating FilterBloc with core services');
        final filterBloc = FilterBloc(
          fetchService: _coreFetchService,
          saveService: _coreSaveService,
        );

        _logger.i('Adding LoadFilterEvent to FilterBloc');
        filterBloc.add(LoadFilterEvent());
        return filterBloc;
      },
      child: FilterScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds, // Pass it here
      ),
    );
  }
}
