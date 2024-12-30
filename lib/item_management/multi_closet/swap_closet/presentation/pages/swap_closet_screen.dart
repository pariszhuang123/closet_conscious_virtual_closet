import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/swap_closet_bloc.dart';
import '../../../../../core/filter/presentation/widgets/tab/single_selection_tab/closet_grid_widget.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class SwapClosetScreen extends StatelessWidget {
  final String? currentClosetId;
  final List<String> selectedItemIds;
  final String? closetName;
  final String? closetType;
  final bool? isPublic;
  final DateTime? validDate; // Keep validDate as DateTime

  final CustomLogger logger = CustomLogger('SwapClosetScreen');

  SwapClosetScreen({
    super.key,
    this.currentClosetId,
    required this.selectedItemIds,
    this.closetName,
    this.closetType,
    this.isPublic,
    this.validDate,
  }) {
    logger.i('SwapClosetScreen initialized with:');
    logger.i('selectedItemIds: $selectedItemIds');
    logger.i('currentClosetId: $currentClosetId');
    logger.i('closetName: $closetName');
    logger.i('closetType: $closetType');
    logger.i('isPublic: $isPublic');
    logger.i("validDate (DateTime): $validDate");
  }

  Future<int> _fetchCrossAxisCount() async {
    final coreFetchService = CoreFetchService(); // Replace with your service
    return await coreFetchService.fetchCrossAxisCount(); // Dynamic fetch
  }

  Future<void> _handleConfirmSwap(BuildContext context, String newClosetId) async {
    final bloc = context.read<SwapClosetBloc>();
    try {
      bloc.add(
        ConfirmClosetSwapEvent(
          currentClosetId: currentClosetId,
          newClosetId: newClosetId,
          selectedItemIds: selectedItemIds,
          closetName: closetName,
          closetType: closetType,
          isPublic: isPublic,
          validDate: validDate,
        ),
      );
    } catch (e) {
      logger.e('Error confirming swap: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorSavingCloset)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger the fetch closets event when the widget builds
    context.read<SwapClosetBloc>().add(FetchAllClosetsEvent());

    return Scaffold(
      body: BlocListener<SwapClosetBloc, SwapClosetState>(
        listener: (context, state) {
          if (state is SwapClosetNavigateToMyClosetState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.myCloset,
                  (route) => false,
            );
          } else if (state.status == ClosetSwapStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${S.of(context).errorSavingCloset}: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<SwapClosetBloc, SwapClosetState>(
          builder: (context, state) {
            if (state.status == ClosetSwapStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ClosetSwapStatus.failure && state.error != null) {
              return Center(
                child: Text(
                  '${S.of(context).errorFetchingClosets}: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return FutureBuilder<int>(
              future: _fetchCrossAxisCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  logger.e('Error fetching crossAxisCount: ${snapshot.error}');
                  return Center(child: Text(S.of(context).failedToLoadItems));
                }

                final crossAxisCount = snapshot.data ?? 3; // Default to 3 if null

                return Column(
                  children: [
                    Expanded(
                      child: ClosetGridWidget(
                        closets: state.closets,
                        selectedClosetId: state.selectedClosetId ?? '',
                        onSelectCloset: (closetId) {
                          context.read<SwapClosetBloc>().add(SelectNewClosetIdEvent(closetId));
                        },
                        crossAxisCount: crossAxisCount, // Pass the fetched value
                      ),
                    ),
                    if (state.selectedClosetId != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => _handleConfirmSwap(context, state.selectedClosetId!),
                          child: Text(S.of(context).confirmSwap),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}