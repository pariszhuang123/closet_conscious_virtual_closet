import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../user_management/user_update/presentation/bloc/version_bloc.dart';
import '../../user_management/core/data/services/user_fetch_service.dart';
import '../connectivity/presentation/blocs/connectivity_bloc.dart';
import 'app_initializer.dart'; // 👈 Your screen logic
import '../../user_management/user_service_locator.dart';

class AppInitializerProvider extends StatelessWidget {
  final Widget child;

  const AppInitializerProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
          locator<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<VersionBloc>(
          create: (_) => VersionBloc(locator<UserFetchSupabaseService>())
            ..add(CheckVersionEvent()),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (_) => ConnectivityBloc(
            connectivity: Connectivity(),
            httpClient: http.Client(),
          )..add(ConnectivityChecked()),
        ),
      ],
      child: AppInitializer(child: child), // 👈 Pass GoRouter child
    );
  }
}
