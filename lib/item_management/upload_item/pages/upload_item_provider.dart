import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/upload_bloc.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import 'upload_item_view.dart';

class UploadItemProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const UploadItemProvider({super.key, required this.myClosetTheme});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final userId = authBloc.userId;

    if (userId == null) {
      return const Center(child: Text('User not authenticated'));
    }

    return BlocProvider(
      create: (context) => UploadBloc(userId: userId),
      child: UploadItemView(myClosetTheme: myClosetTheme),
    );
  }
}
