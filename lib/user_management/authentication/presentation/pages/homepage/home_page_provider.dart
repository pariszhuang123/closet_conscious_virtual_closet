import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../user_management/user_update/presentation/bloc/version_bloc.dart';  // Replace with actual VersionBloc import
import 'home_page_screen.dart';  // The new screen file

class HomePageProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const HomePageProvider({
    super.key,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<VersionBloc>(),  // VersionBloc via GetIt
        ),
      ],
      child: HomePageScreen(
        myClosetTheme: myClosetTheme
      ),
    );
  }
}
