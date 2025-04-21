import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/utilities/app_router.dart';
import 'core/theme/my_closet_theme.dart';
import 'generated/l10n.dart';
import 'core/init/app_initializer_provider.dart';

class MainApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MainApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return AppInitializerProvider(
      child: MaterialApp.router(
        routerConfig: appRouter, // 👈 Pass it here
        debugShowCheckedModeBanner: false,
        theme: myClosetTheme,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
