import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../presentation/bloc/customize_bloc.dart';
import '../../core_enums.dart';
import '../../data/type_data.dart';
import '../../widgets/layout/icon_row_builder.dart';
import '../../../generated/l10n.dart';

class CustomizeScreen extends StatelessWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).customizeClosetView),
        actions: [
          // Reset to Default Icon Button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: S.of(context).resetToDefault,
            onPressed: () {
              context.read<CustomizeBloc>().add(ResetCustomizeEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<CustomizeBloc, CustomizeState>(
        builder: (context, state) {
          if (state.saveStatus == SaveStatus.inProgress) {
            return const Center(child: ClosetProgressIndicator());
          }

          return Column(
            children: [
              // Grid Size Picker using buildIconRows
              ...buildIconRows(
                TypeDataList.gridSizes(context),
                state.gridSize.toString(), // Pass the selected grid size as a string
                    (selectedKey) {
                  context.read<CustomizeBloc>().add(
                    UpdateCustomizeEvent(gridSize: int.parse(selectedKey)),
                  );
                },
                context,
                false,
              ),
              const SizedBox(height: 16),

              // Sort Category Picker using buildIconRows
              ...buildIconRows(
                TypeDataList.sortCategories(context),
                state.sortCategory,
                    (selectedKey) {
                  context.read<CustomizeBloc>().add(
                    UpdateCustomizeEvent(sortCategory: selectedKey),
                  );
                },
                context,
                false,
              ),
              const SizedBox(height: 16),

              // Sort Order Picker using buildIconRows
              ...buildIconRows(
                TypeDataList.sortOrder(context),
                state.sortOrder,
                    (selectedKey) {
                  context.read<CustomizeBloc>().add(
                    UpdateCustomizeEvent(sortOrder: selectedKey),
                  );
                },
                context,
                false,
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  context.read<CustomizeBloc>().add(SaveCustomizeEvent());
                },
                child: Text(S.of(context).saveCustomization),
              ),
            ],
          );
        },
      ),
    );
  }
}
