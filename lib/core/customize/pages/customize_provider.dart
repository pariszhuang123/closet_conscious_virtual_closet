import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/core_fetch_services.dart';
import '../../data/services/core_save_services.dart';
import '../presentation/bloc/customize_bloc.dart';
import 'customize_screen.dart';

class CustomizeProvider extends StatelessWidget {
  final bool isFromMyCloset;

  const CustomizeProvider({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    final coreFetchService = CoreFetchService();
    final coreSaveService = CoreSaveService();

    return BlocProvider(
      create: (context) {
        // Initialize ArrangeBloc with required services
        final customizeBloc = CustomizeBloc(
          fetchService: coreFetchService,
          saveService: coreSaveService,
        );
        customizeBloc.add(LoadCustomizeEvent()); // Load initial arrangement settings
        return customizeBloc;
      },
      child: CustomizeScreen(isFromMyCloset: isFromMyCloset), // Provide ArrangeScreen with the initialized ArrangeBloc
    );
  }
}
