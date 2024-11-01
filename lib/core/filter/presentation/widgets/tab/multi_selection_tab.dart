import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/layout/icon_row_builder.dart';
import '../../../../data/type_data.dart';
import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';

class MultiSelectionTab extends StatelessWidget {
  final FilterState state;

  const MultiSelectionTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Type Selection
          Text(S.of(context).selectItemType, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.itemGeneralTypes(context),
            state.itemType ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(itemType: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          // Occasion Selection
          Text(S.of(context).selectOccasion, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.occasions(context),
            state.occasion ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(occasion: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          // Season Selection
          Text(S.of(context).selectSeason, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.seasons(context),
            state.season ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(season: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectClothingType, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.clothingTypes(context),
            state.clothingType ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingType: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectClothingLayer, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.clothingLayers(context),
            state.clothingLayer ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingLayer: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectAccessoryType, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.accessoryTypes(context),
            state.accessoryType ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(accessoryType: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectShoeType, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.shoeTypes(context),
            state.shoesType ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(shoesType: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectColour, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.colour(context),
            state.colour ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(colour: [dataKey]));
            },
            context,
            true,
            true,
          ),
          const SizedBox(height: 12),

          Text(S.of(context).selectColourVariation, style: theme.textTheme.titleMedium),
          ...buildIconRows(
            TypeDataList.colourVariations(context),
            state.colourVariations ?? [],
                (dataKey) {
              context.read<FilterBloc>().add(UpdateFilterEvent(colourVariations: [dataKey]));
            },
            context,
            true,
            true,
          ),
        ],
      ),
    );
  }
}
