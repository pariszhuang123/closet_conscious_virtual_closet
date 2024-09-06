import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class PremiumCalendarBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumCalendarBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).calendarPremiumFeature,
      description: S.of(context).reviewOutfitsInCalendar,
      rpcFunctionName: 'increment_calendar_request',
    );
  }
}
