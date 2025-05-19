import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/services/item_save_service.dart';
import '../bloc/qr_scan_bloc.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';
import 'qr_scan_screen.dart';

class QrScanProvider extends StatelessWidget {
  const QrScanProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrScanBloc(
        itemSaveService: locator<ItemSaveService>(),
        authBloc: locator<AuthBloc>(),
      ),
      child: const QrScanScreen(),
    );
  }
}
