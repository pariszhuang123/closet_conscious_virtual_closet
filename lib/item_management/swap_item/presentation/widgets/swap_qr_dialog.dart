import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import 'item_qr_code.dart';
import '../bloc/qr_scan_bloc.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../item_service_locator.dart';
import '../../../core/data/services/item_save_service.dart';
import '../../../../user_management/user_service_locator.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';

void showSwapQrDialog(BuildContext context, String itemId) {
  final theme = myClosetTheme;
  final s = S.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider(
        create: (_) => QrScanBloc(
          itemSaveService: itemLocator<ItemSaveService>(),
          authBloc: locator<AuthBloc>(),
        ),
        child: Builder(
          builder: (innerContext) {
            innerContext.read<QrScanBloc>().add(StartListeningForTransferEvent());

            return CustomAlertDialog(
              title: s.swapDialogTitle,
              content: BlocListener<QrScanBloc, QrScanState>(
                listenWhen: (prev, curr) => curr is QrItemTransferredAway,
                listener: (innerContext, state) {
                  innerContext.read<QrScanBloc>().add(StopListeningForTransferEvent());
                  Navigator.of(innerContext).pop();
                  innerContext.goNamed(AppRoutesName.myCloset);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ItemQrCode(itemId: itemId),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              theme: theme,
              iconButton: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  innerContext.read<QrScanBloc>().add(StopListeningForTransferEvent());
                  Navigator.of(innerContext).pop();
                },
              ),
            );
          },
        ),
      );
    },
  );
}
