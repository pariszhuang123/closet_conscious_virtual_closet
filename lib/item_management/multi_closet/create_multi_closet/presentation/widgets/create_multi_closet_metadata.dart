import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart';

class CreateMultiClosetMetadata extends StatelessWidget {
  final TextEditingController closetNameController;
  final TextEditingController? monthsController;
  final String closetType; // 'permanent' or 'temporary'
  final bool isPublic; // true for public, false for private
  final ThemeData theme;

  const CreateMultiClosetMetadata({
    super.key,
    required this.closetNameController,
    this.monthsController,
    required this.closetType,
    required this.isPublic,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Closet Name Input
            TextField(
              controller: closetNameController,
              decoration: InputDecoration(
                labelText: S.of(context).closetName,
                border: const OutlineInputBorder(),
                labelStyle: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // Closet Type Switch
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).closetType, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      closetType == 'permanent'
                          ? S.of(context).permanentCloset
                          : S.of(context).disappearingCloset,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Switch(
                      value: closetType == 'permanent',
                      onChanged: null, // Remove callback
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Conditional Metadata Fields
            if (closetType == 'permanent') ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).publicOrPrivate, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPublic ? S.of(context).public : S.of(context).private,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Switch(
                        value: isPublic,
                        onChanged: null, // Remove callback
                      ),
                    ],
                  ),
                ],
              ),
            ] else if (closetType == 'temporary') ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).disappearAfterMonths, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: S.of(context).months,
                      border: const OutlineInputBorder(),
                      labelStyle: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
