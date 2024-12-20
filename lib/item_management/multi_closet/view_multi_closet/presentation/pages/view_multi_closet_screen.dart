import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/view_multi_closet_bloc.dart';
import '../../../../../core/filter/presentation/widgets/tab/single_selection_tab/closet_grid_widget.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/data/type_data.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/paywall/data/feature_key.dart';
import '../../../../../core/data/services/core_fetch_services.dart';


class ViewMultiClosetScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final CustomLogger logger = CustomLogger('ViewMultiClosetScreen');
  late final Future<int> crossAxisCountFuture;

  ViewMultiClosetScreen({
    super.key,
    required this.isFromMyCloset,
  }) {
    crossAxisCountFuture = _getCrossAxisCount();
  }

  Future<int> _getCrossAxisCount() async {
    final coreFetchService = CoreFetchService();
    try {
      return await coreFetchService.fetchCrossAxisCount();
    } catch (e) {
      logger.e("Failed to fetch crossAxisCount: $e");
      return 3; // Default to 3 if an error occurs
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());

    final createClosetTypeData = TypeDataList.createCloset(context);
    final allClosetsTypeData = TypeDataList.allClosets(context);

    logger.i('Building ViewMultiClosetScreen');

    return BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
      listener: (context, state) {
        if (state is MultiClosetAccessDeniedState) {
          // Navigate to the payment page if access is denied
          logger.w('Access denied: Navigating to payment page');
          Navigator.pushReplacementNamed(
              context,
              AppRoutes.payment,
              arguments: {
                'featureKey': FeatureKey.multicloset, // Use a relevant feature key
                'isFromMyCloset': isFromMyCloset,
                'previousRoute': AppRoutes.myCloset,
                'nextRoute': AppRoutes.viewMultiCloset,
              },
          );
        } else if (state is CreateMultiClosetNavigationState) {
          logger.i('Navigating to Create Multi Closet screen.');
          Navigator.pushNamed(context, AppRoutes.createMultiCloset);
        } else if (state is EditSingleMultiClosetNavigationState) {
          logger.i('Navigating to Edit Single Multi Closet screen');
          Navigator.pushNamed(
            context,
            AppRoutes.editMultiCloset,
          );
        } else if (state is EditAllMultiClosetNavigationState) {
          logger.i('Navigating to Edit All Multi Closet screen');
          Navigator.pushNamed(
            context,
            AppRoutes.editMultiCloset,
          );
        } else {
          logger.d('Unhandled state in MultiClosetNavigationBloc: ${state.runtimeType}');
        }
      },
      child: Column(
        children: [
          // Buttons Row with NavigationTypeButton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavigationTypeButton(
                label: createClosetTypeData.getName(context),
                selectedLabel: '',
                onPressed: () {
                  logger.i('Add Closet Button Pressed');
                  context
                      .read<MultiClosetNavigationBloc>()
                      .add(NavigateToCreateMultiCloset());
                },
                assetPath: createClosetTypeData.assetPath,
                isFromMyCloset: true,
                usePredefinedColor: createClosetTypeData.usePredefinedColor,
                buttonType: ButtonType.primary, // Example ButtonType
                isSelected: false,
              ),
              NavigationTypeButton(
                label: allClosetsTypeData.getName(context),
                selectedLabel: '',
                onPressed: () {
                  logger.i('All Closet Button Pressed');
                  context
                      .read<MultiClosetNavigationBloc>()
                      .add(NavigateToEditAllMultiCloset());
                },
                assetPath: allClosetsTypeData.assetPath,
                isFromMyCloset: true,
                usePredefinedColor: allClosetsTypeData.usePredefinedColor,
                buttonType: ButtonType.primary, // Example ButtonType
                isSelected: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Closet Grid
          Expanded(
            child: FutureBuilder<int>(
              future: crossAxisCountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  logger.e("Error fetching crossAxisCount: ${snapshot.error}");
                  return Center(child: Text(S.of(context).failedToLoadItems));
                }

                final crossAxisCount = snapshot.data ?? 3;

                return BlocBuilder<ViewMultiClosetBloc, ViewMultiClosetState>(
                  builder: (context, state) {
                    if (state is ViewMultiClosetsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ViewMultiClosetsLoaded) {
                      return ClosetGridWidget(
                        closets: state.closets,
                        selectedClosetId: '',
                        crossAxisCount: crossAxisCount,
                        onSelectCloset: (closetId) {
                          context
                              .read<MultiClosetNavigationBloc>()
                              .add(NavigateToEditSingleMultiCloset(closetId));
                        },
                      );
                    } else if (state is ViewMultiClosetsError) {
                      return Center(child: Text(state.error));
                    }

                    return Center(child: Text(S.of(context).noClosetsFound));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
