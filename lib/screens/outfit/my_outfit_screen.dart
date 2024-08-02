import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import 'my_outfit_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class MyOutfitScreen extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitScreen({super.key, required this.myOutfitTheme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateOutfitItemBloc(Supabase.instance.client),
      child: MyOutfitView(myOutfitTheme: myOutfitTheme),
    );
  }
}
