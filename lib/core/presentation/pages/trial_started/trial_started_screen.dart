import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/trial_bloc/trial_started_bloc.dart';
import '../../widgets/trial_started/trial_list.dart';
import '../../../widgets/dialog/trial_started_dialog.dart';
import '../../../utilities/routes.dart';
import '../../../utilities/logger.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';

class TrialStartedScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String selectedFeatureRoute;
  final CustomLogger _logger = CustomLogger(
      'TrialStartedScreen'); // ✅ Initialize logger

  TrialStartedScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedFeatureRoute, // ✅ Directly passes AppRoutes.filter instead of "filter"
  }) {
    // ✅ Log constructor values when initialized
    _logger.i("Screen Initialized:");
    _logger.d("isFromMyCloset: $isFromMyCloset");
    _logger.d("returnRoute: $selectedFeatureRoute");

    if (selectedFeatureRoute.isEmpty) {
      _logger.w(
          "⚠️ Warning: selectedFeatureRoute is empty. This may cause navigation issues.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Theme(
        data: isFromMyCloset ? myClosetTheme : myOutfitTheme, // Dynamically switch theme
        child: PopScope(
      canPop: false, // ✅ Prevents back navigation
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(localization.trialStartedTitle),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface),
              onPressed: () {
                const route = AppRoutes.myCloset;
                _logger.i("Close button tapped. Navigating to: $route");
                Navigator.pushReplacementNamed(context, route);
              },
            ),
          ],
        ),
        body: BlocListener<TrialBloc, TrialState>(
          listenWhen: (previous, current) => current is TrialActivated,
          listener: (context, state) {
            if (state is TrialActivated) {
              _logger.i("TrialActivated state detected. Showing dialog...");
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    TrialStartedDialog(
                      onClose: () {
                        _navigateToFeature(context);
                      },
                      selectedFeature: selectedFeatureRoute, // ✅ Uses AppRoutes.filter, not "filter"
                    ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ✅ **Show Trial List Above Button**
                TrialList(isFromMyCloset: isFromMyCloset),

                const SizedBox(height: 20),

                /// ✅ **Localized Trial Message**
                Text(
                  localization.trialStartedMessage,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                ),

                const SizedBox(height: 20),

                /// ✅ **BlocBuilder for Button State**
                BlocBuilder<TrialBloc, TrialState>(
                  builder: (context, state) {
                    if (state is TrialActivationInProgress) {
                      _logger.i(
                          "TrialActivationInProgress: Showing loading indicator.");
                      return const Center(child: ClosetProgressIndicator());
                    }

                    return Center(
                      child: ElevatedButton(
                        onPressed: state is TrialActivationInProgress
                            ? null
                            : () {
                          _logger.i(
                              "Start Free Trial button tapped. Dispatching event...");
                          context.read<TrialBloc>().add(ActivateTrialEvent());
                        },
                        child: Text(localization.startFreeTrial),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
        )
    );
  }

  /// ✅ **Navigates to the correct AppRoutes value directly**
  void _navigateToFeature(BuildContext context) {
    _logger.i("Navigating to feature...");
    _logger.d("Initial selectedFeatureRoute: $selectedFeatureRoute");

    final safeRoute = selectedFeatureRoute.isNotEmpty ? selectedFeatureRoute : AppRoutes.myCloset;
    _logger.i("🚀 Final Navigation Route: $safeRoute");

    Navigator.of(context).pushReplacementNamed(
      safeRoute,
      arguments: {
        'isFromMyCloset': isFromMyCloset,
        'selectedFeatureRoute': safeRoute, // ✅ Ensure returnRoute is passed
      },
    );
  }
}