import 'package:flutter/material.dart';
import '../../../../../core/data/type_data.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/layout/icon_row_builder.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';

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
            CustomTextFormField(
              controller: itemNameController,
              labelText: S.of(context).item_name,
              hintText: S.of(context).ItemNameHint, // No hint text for item name
              labelStyle: myClosetTheme.textTheme.bodyMedium,
              focusedBorderColor: myClosetTheme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: amountSpentController,
              labelText: S.of(context).amountSpentLabel,
              hintText: S.of(context).enterAmountSpentHint,
              labelStyle: myClosetTheme.textTheme.bodyMedium,
              focusedBorderColor: myClosetTheme.colorScheme.primary,
              errorText: amountSpentError,
              keyboardType: TextInputType.number,
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
                  selectedItemType != null ? [selectedItemType!] : [],
                      (selectedKeys) => onItemTypeChanged(selectedKeys.first),
                  context,
                  true,
                  false,
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
                  selectedOccasion != null ? [selectedOccasion!] : [],
                      (selectedKeys) {
                    onOccasionChanged(selectedKeys.first);
                  },
                  context,
                  true,
                  false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
