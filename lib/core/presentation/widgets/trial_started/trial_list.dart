import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/button/navigation_type_button.dart';
import '../../bloc/trial_bloc/trial_started_bloc.dart';
import '../../../data/type_data.dart';
import '../../../core_enums.dart';

class TrialList extends StatelessWidget {
  final bool isFromMyCloset;

  const TrialList({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrialBloc, TrialState>(
      builder: (context, state) {
        List<TypeData> deniedFeatures = [];

        if (state is AccessFilterFeatureDenied) {
          deniedFeatures.add(TypeDataList.filter(context));
        }
        if (state is AccessMultiClosetFeatureDenied) {
          deniedFeatures.add(TypeDataList.addCloset(context));
        }
        if (state is AccessCustomizeFeatureDenied) {
          deniedFeatures.add(TypeDataList.arrange(context));
        }
        if (state is AccessCalendarFeatureDenied) {
          deniedFeatures.add(TypeDataList.calendar(context));
        }
        if (state is AccessOutfitCreationFeatureDenied) {
          deniedFeatures.add(TypeDataList.outfitsUpload(context));
        }
        if (state is TrialAccessDenied) {
          deniedFeatures.addAll(state.deniedStates.map((deniedState) {
            return _mapDeniedStateToTypeData(deniedState, context);
          }).toList());
        }

        if (deniedFeatures.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: deniedFeatures
              .map((typeData) => _buildTrialPoint(typeData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildTrialPoint(TypeData typeData, BuildContext context) {
    final theme = Theme.of(context);
    final explanation = _getExplanation(typeData, context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationTypeButton(
            label: '',
            selectedLabel: '',
            assetPath: typeData.assetPath,
            isFromMyCloset: isFromMyCloset,
            usePredefinedColor: false,
            buttonType: ButtonType.secondary,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeData.getName(context),
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  explanation,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ **Handles translations in UI**
  String _getExplanation(TypeData typeData, BuildContext context) {
    final localization = S.of(context);

    switch (typeData.key) {
      case 'filter_filter':
        return localization.trialIncludedFilter;
      case 'arrange':
        return localization.trialIncludedCustomize;
      case 'addCloset_addCloset':
        return localization.trialIncludedClosets;
      case 'outfits_upload':
        return localization.trialIncludedOutfits;
      case 'calendar':
        return localization.trialIncludedCalendar;
      default:
        return '';
    }
  }

  /// ✅ **Maps Bloc States to `TypeData` in UI**
  TypeData _mapDeniedStateToTypeData(TrialState state, BuildContext context) {
    if (state is AccessFilterFeatureDenied) return TypeDataList.filter(context);
    if (state is AccessMultiClosetFeatureDenied) return TypeDataList.addCloset(context);
    if (state is AccessCustomizeFeatureDenied) return TypeDataList.arrange(context);
    if (state is AccessCalendarFeatureDenied) return TypeDataList.calendar(context);
    if (state is AccessOutfitCreationFeatureDenied) return TypeDataList.outfitsUpload(context);
    throw Exception('Unhandled denied state: $state');
  }
}
