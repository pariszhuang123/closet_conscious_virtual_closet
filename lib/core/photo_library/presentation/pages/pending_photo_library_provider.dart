import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/photo_library_bloc.dart';
import '../../usecase/photo_library_service.dart';
import '../../../data/services/core_save_services.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import 'pending_photo_library_screen.dart';

import 'package:get_it/get_it.dart';

final GetIt coreLocator = GetIt.instance;

class PendingPhotoLibraryProvider extends StatelessWidget {
  const PendingPhotoLibraryProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoLibraryBloc>(
          create: (context) => PhotoLibraryBloc(
            photoLibraryService: PhotoLibraryService(
              coreLocator<CoreSaveService>(),
            ),
          ),
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (_) => MultiSelectionItemCubit(),
        ),
      ],
      child: const PendingPhotoLibraryScreen(),
    );
  }
}
