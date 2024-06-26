import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../core/theme/my_closet_theme.dart';
import '../../../core/theme/my_outfit_theme.dart';
import '../../../core/widgets/icon_row_builder.dart';
import '../../../core/data/type_data.dart';

class DeclutterOptionsBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const DeclutterOptionsBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    ColorScheme colorScheme = theme.colorScheme;

    List<TypeData> typeDataList = TypeDataList.archiveOptions(context);

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).declutterOptions,
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...buildIconRows(
              typeDataList,
              null, // You may want to manage state for selectedKey if applicable
                  (selectedKey) {
                Navigator.pop(context); // You can add further logic here
              },
              context,
            ),
          ],
        ),
      ),
    );
  }
}
