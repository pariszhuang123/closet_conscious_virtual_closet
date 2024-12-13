import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';
import '../bloc/edit_multi_closet_bloc/edit_multi_closet_bloc.dart';

class EditClosetActionButton extends StatelessWidget {
  const EditClosetActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
      builder: (context, selectionItemState) {
        return BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
          builder: (context, metadataState) {
            // Determine button visibility and text
            if (selectionItemState.hasSelectedItems) {
              return _buildButton(
                context: context,
                text: S.of(context).chooseSwap,
                metadataState: metadataState,
              );
            } else if (metadataState is EditClosetMetadataAvailable) {
              return _buildButton(
                context: context,
                text: S.of(context).update,
                metadataState: metadataState,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required EditClosetMetadataState metadataState,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ThemedElevatedButton(
          text: text,
          onPressed: () {
            if (metadataState is EditClosetMetadataAvailable) {
              context.read<EditMultiClosetBloc>().add(EditMultiClosetValidate(
                closetName: metadataState.metadata.closetName,
                closetType: metadataState.metadata.closetType,
                isPublic: metadataState.metadata.isPublic,
                validDate: metadataState.metadata.validDate,
              ));
            }
          },
        ),
      ),
    );
  }
}
