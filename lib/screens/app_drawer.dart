import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/bloc/theme_bloc.dart';
import '../core/theme/bloc/theme_event.dart';
import '../core/theme/my_closet_theme.dart';
import '../core/theme/my_outfit_theme.dart';
import '../../../generated/l10n.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.backgroundColor,
            ),
            child: Text(
              S.of(context).AppName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
          ListTile(
            title: const Text('My Closet'),
            onTap: () {
              BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(myClosetTheme));
              Navigator.pushReplacementNamed(context, '/myCloset');
            },
          ),
          ListTile(
            title: const Text('My Outfit'),
            onTap: () {
              BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(myOutfitTheme));
              Navigator.pushReplacementNamed(context, '/myOutfit');
            },
          ),
        ],
      ),
    );
  }
}
