import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Import GetIt

import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../presentation/bloc/customize_bloc.dart';
import 'customize_screen.dart';
import 'customize_access_wrapper.dart';
import '../../../utilities/logger.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';

class CustomizeProvider extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final String returnRoute;

  const CustomizeProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.returnRoute,
  });

  @override
  State<CustomizeProvider> createState() => _CustomizeProviderState();
}

class _CustomizeProviderState extends State<CustomizeProvider> {
  final CustomLogger _logger = CustomLogger('CustomizeProvider');

  @override
  void initState() {
    super.initState();
    _logger.i('CustomizeProvider initialized with isFromMyCloset: ${widget.isFromMyCloset}, selectedItemIds: ${widget.selectedItemIds}');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building CustomizeProvider widgets');

    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomizeBloc>(
          create: (_) => CustomizeBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider<TutorialBloc>(
          create: (_) => TutorialBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider<TrialBloc>(
          create: (_) => TrialBloc(coreFetchService),
        ),
        BlocProvider<PremiumFeatureAccessBloc>(
          create: (_) => PremiumFeatureAccessBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
      ],
      child: CustomizeAccessWrapper(
        isFromMyCloset: widget.isFromMyCloset,
        child: CustomizeScreen(
          isFromMyCloset: widget.isFromMyCloset,
          selectedItemIds: widget.selectedItemIds,
          returnRoute: widget.returnRoute,
        ),
      ),
    );
  }
}
