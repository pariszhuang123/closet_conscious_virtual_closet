import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/layout/icon_row_builder.dart';
import '../../../../data/type_data.dart';
import '../../bloc/filter_bloc.dart';
import '../../../../../generated/l10n.dart';
import '../../../../utilities/logger.dart';

class MultiSelectionTab extends StatelessWidget {
  final FilterState state;
  final CustomLogger _logger = CustomLogger('MultiSelectionTab');

  MultiSelectionTab({super.key, required this.state}) {
    _logger.i('MultiSelectionTab initialized with state: $state');
  }

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
                (selectedKeys) {  // Update to accept List<String>
              context.read<FilterBloc>().add(UpdateFilterEvent(itemType: selectedKeys));
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
                (selectedKeys) {  // Update to accept List<String>
              context.read<FilterBloc>().add(UpdateFilterEvent(occasion: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(season: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingType: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingLayer: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(accessoryType: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(shoesType: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(colour: selectedKeys));
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
                (selectedKeys) {
              context.read<FilterBloc>().add(UpdateFilterEvent(colourVariations: selectedKeys));
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
