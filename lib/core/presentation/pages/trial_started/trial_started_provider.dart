import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../bloc/trial_bloc/trial_started_bloc.dart';
import '../../../data/services/core_fetch_services.dart';
import 'trial_started_screen.dart';

class TrialStartedProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final String selectedFeatureRoute;

  const TrialStartedProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedFeatureRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrialBloc(GetIt.instance<CoreFetchService>())..add(CheckTrialAccessEvent()),
      child: TrialStartedScreen(
        isFromMyCloset: isFromMyCloset,
        selectedFeatureRoute: selectedFeatureRoute, // ✅ Pass AppRoutes value directly
      ),
    );
  }
}
