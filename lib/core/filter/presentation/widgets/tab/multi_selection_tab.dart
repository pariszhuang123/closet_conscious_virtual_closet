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

    _logger.i('Building MultiSelectionTab widget');

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
                (selectedKeys) {
              _logger.d('User selected item type: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(itemType: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with itemType: $selectedKeys');
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
                (selectedKeys) {
              _logger.d('User selected occasion: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(occasion: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with occasion: $selectedKeys');
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
              _logger.d('User selected season: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(season: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with season: $selectedKeys');
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
              _logger.d('User selected clothing type: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingType: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with clothingType: $selectedKeys');
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
              _logger.d('User selected clothing layer: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(clothingLayer: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with clothingLayer: $selectedKeys');
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
              _logger.d('User selected accessory type: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(accessoryType: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with accessoryType: $selectedKeys');
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
              _logger.d('User selected shoe type: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(shoesType: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with shoesType: $selectedKeys');
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
              _logger.d('User selected colour: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(colour: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with colour: $selectedKeys');
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
              _logger.d('User selected colour variation: $selectedKeys');
              context.read<FilterBloc>().add(UpdateFilterEvent(colourVariations: selectedKeys));
              _logger.i('Dispatched UpdateFilterEvent with colourVariations: $selectedKeys');
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
