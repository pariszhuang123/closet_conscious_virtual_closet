// closet_provider.dart
import 'package:closet_conscious/user_management/core/data/services/user_fetch_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc.dart';
import '../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import 'closet_screen.dart';

class MyClosetProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const MyClosetProvider({
    super.key,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = ItemFetchService(); // Or fetch via GetIt if preferred
    final userFetchSupabaseService = UserFetchSupabaseService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadStreakBloc>(
          create: (context) => UploadStreakBloc(itemFetchService)..add(CheckUploadStatus()),
        ),
        BlocProvider<NavigateItemBloc>(
          create: (context) => NavigateItemBloc(
            itemFetchService: itemFetchService,
          ),
        ),
        BlocProvider<VersionBloc>( // Adding VersionBloc here
          create: (context) => VersionBloc(userFetchSupabaseService)..add(CheckVersionEvent()), // Dispatch the initial event
        ),
      ],
      child: MyClosetScreen(
        myClosetTheme: myClosetTheme,
      ),
    );
  }
}
