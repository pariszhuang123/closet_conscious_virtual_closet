import 'package:closet_conscious/screens/closet/closet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';

class MyClosetProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const MyClosetProvider({super.key,required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = ItemFetchService(); // Assuming this is how you get ItemFetchService instance

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadStreakBloc>(
          create: (context) => UploadStreakBloc(itemFetchService)..add(CheckUploadStatus()), // Start by checking upload status
        ),
      ],
      child: MyClosetScreen(myClosetTheme: myClosetTheme),
    );
  }
}
