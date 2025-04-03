import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/trial_bloc/trial_started_bloc.dart';
import '../../widgets/trial_started/trial_list.dart';
import '../../../widgets/dialog/trial_started_dialog.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/logger.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';

class TrialStartedScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String selectedFeatureRoute;
  final CustomLogger _logger = CustomLogger('TrialStartedScreen');

  TrialStartedScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedFeatureRoute,
  }) {
    _logger.i("Screen Initialized:");
    _logger.d("isFromMyCloset: $isFromMyCloset");
    _logger.d("returnRoute: $selectedFeatureRoute");

    if (selectedFeatureRoute.isEmpty) {
      _logger.w("⚠️ Warning: selectedFeatureRoute is empty. This may cause navigation issues.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Theme(
      data: isFromMyCloset ? myClosetTheme : myOutfitTheme,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(localization.trialStartedTitle),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () {
                  const route = AppRoutesName.myCloset;
                  _logger.i("Close button tapped. Navigating to: $route");
                  context.goNamed(route);
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
                  builder: (context) => TrialStartedDialog(
                    onClose: () {
                      _navigateToFeature(context);
                    },
                    selectedFeature: selectedFeatureRoute,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ **Scrollable Trial List**
                  Expanded(
                    child: SingleChildScrollView(
                      child: TrialList(isFromMyCloset: isFromMyCloset),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// ✅ **Trial Message (Always Visible)**
                  Text(
                    localization.trialStartedMessage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),

                  /// ✅ **Fixed Button at the Bottom**
                  BlocBuilder<TrialBloc, TrialState>(
                    builder: (context, state) {
                      if (state is TrialActivationInProgress) {
                        _logger.i("TrialActivationInProgress: Showing loading indicator.");
                        return const Center(child: ClosetProgressIndicator());
                      }

                      return Center(
                        child: ElevatedButton(
                          onPressed: state is TrialActivationInProgress
                              ? null
                              : () {
                            _logger.i("Start Free Trial button tapped. Dispatching event...");
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
      ),
    );
  }

  void _navigateToFeature(BuildContext context) {
    _logger.i("Navigating to feature...");
    _logger.d("Initial selectedFeatureRoute: $selectedFeatureRoute");

    final safeRoute = selectedFeatureRoute.isNotEmpty ? selectedFeatureRoute : AppRoutesName.myCloset;
    _logger.i("🚀 Final Navigation Route: $safeRoute");

    context.goNamed(
      safeRoute,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'selectedFeatureRoute': safeRoute,
      },
    );
  }
}
