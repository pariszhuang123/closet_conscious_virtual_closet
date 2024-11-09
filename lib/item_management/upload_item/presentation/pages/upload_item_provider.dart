import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/upload_item_bloc.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import 'upload_item_screen.dart';
import '../../../../core/utilities/logger.dart';

class UploadItemProvider extends StatelessWidget {
  final ThemeData myClosetTheme;
  final String imageUrl;

  final CustomLogger _logger = CustomLogger('UploadItemProvider');

  UploadItemProvider({
    super.key,
    required this.myClosetTheme,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building UploadItemProvider');
    _logger.d('Image URL passed to UploadItemProvider: $imageUrl');

    final authBloc = context.read<AuthBloc>();
    final userId = authBloc.userId;

    if (userId == null) {
      _logger.e('User is not authenticated. Unable to proceed.');
      return const Center(child: Text('User not authenticated'));
    }
    _logger.i('User is authenticated. User ID: $userId');
    _logger.d('Creating UploadItemBloc with userId: $userId');

    return BlocProvider(
      create: (context) => UploadItemBloc(
          userId: userId),
      child: UploadItemScreen(myClosetTheme: myClosetTheme, imageUrl: imageUrl),
    );
  }
}
