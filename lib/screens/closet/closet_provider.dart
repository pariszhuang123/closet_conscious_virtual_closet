import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import '../../item_management/view_items/presentation/bloc/view_items_bloc.dart'; // Import ViewItemsBloc
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadStreakBloc>(
          create: (context) => UploadStreakBloc()..add(CheckUploadStatus()),
        ),
        BlocProvider<NavigateItemBloc>(
          create: (context) => NavigateItemBloc(
            itemFetchService: itemFetchService,
          ),
        ),
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc()..add(FetchItemsEvent(0)),
        ),
      ],
      child: MyClosetScreen(
        myClosetTheme: myClosetTheme,
      ),
    );
  }
}
