import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/icon_row_builder.dart';
import '../../presentation/bloc/upload_item_bloc.dart';

class MetadataFirstPage extends StatelessWidget {
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;
  final String? selectedItemType;
  final String? selectedOccasion;
  final Function(String) onItemTypeChanged;
  final Function(String) onOccasionChanged;
  final String? amountSpentError;
  final ThemeData myClosetTheme;

  const MetadataFirstPage({
    super.key,
    required this.itemNameController,
    required this.amountSpentController,
    required this.selectedItemType,
    required this.selectedOccasion,
    required this.onItemTypeChanged,
    required this.onOccasionChanged,
    required this.amountSpentError,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: S.of(context).item_name,
                labelStyle: myClosetTheme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountSpentController,
              decoration: InputDecoration(
                labelText: S.of(context).amountSpentLabel,
                hintText: S.of(context).enterAmountSpentHint,
                errorText: amountSpentError,
                labelStyle: myClosetTheme.textTheme.bodyMedium,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                context.read<UploadItemBloc>().add(ValidateFormPage1(
                  itemName: itemNameController.text.trim(),
                  amountSpentText: value,
                  selectedItemType: selectedItemType,
                  selectedOccasion: selectedOccasion,
                ));
              },
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).selectItemType,
              style: myClosetTheme.textTheme.bodyMedium,
            ),
            SafeArea(
              child: Column(
                children: buildIconRows(
                  TypeDataList.itemGeneralTypes(context),
                  selectedItemType,
                  onItemTypeChanged,
                  context,
                  true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).selectOccasion,
              style: myClosetTheme.textTheme.bodyMedium,
            ),
            SafeArea(
              child: Column(
                children: buildIconRows(
                  TypeDataList.occasions(context),
                  selectedOccasion,
                  onOccasionChanged,
                  context,
                  true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
