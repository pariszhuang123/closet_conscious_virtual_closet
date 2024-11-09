import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/edit_item_bloc.dart';
import 'edit_item_screen.dart';

class EditItemProvider extends StatelessWidget {
  final String itemId;

  const EditItemProvider({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditItemBloc(itemId: itemId)..add(LoadItemEvent(itemId)),
      child: EditItemScreen(itemId: itemId),
    );
  }
}
