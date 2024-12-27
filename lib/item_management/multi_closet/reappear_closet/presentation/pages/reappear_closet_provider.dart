import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reappear_closet_bloc.dart';
import '../../../../../core/data/services/core_save_services.dart';
import 'reappear_closet_screen.dart';
import '../../../../../core/utilities/logger.dart';

class ReappearClosetProvider extends StatelessWidget {
  final String closetId;
  final String closetName;
  final String closetImage;

  // Initialize a logger specific to ReappearClosetProvider
  static final CustomLogger _logger = CustomLogger('ReappearClosetProvider');

  const ReappearClosetProvider({
    super.key,
    required this.closetId,
    required this.closetName,
    required this.closetImage,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Building ReappearClosetProvider with closetId: $closetId, closetName: $closetName');

    return BlocProvider(
      create: (context) {
        _logger.d('Creating ReappearClosetBloc for closetId: $closetId');
        return ReappearClosetBloc(
          coreSaveService: CoreSaveService(),
        );
      },
      child: Builder(
        builder: (context) {
          _logger.i('Initializing ReappearClosetScreen for closetId: $closetId');
          return ReappearClosetScreen(
            closetId: closetId,
            closetName: closetName,
            closetImage: closetImage,
          );
        },
      ),
    );
  }
}
