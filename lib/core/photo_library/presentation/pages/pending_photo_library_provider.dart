import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../usecase/photo_library_service.dart';
import '../../../data/services/core_save_services.dart';
import '../../../data/services/core_fetch_services.dart';
import 'pending_photo_library_screen.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../utilities/logger.dart';


final GetIt coreLocator = GetIt.instance;

class PendingPhotoLibraryProvider extends StatelessWidget {
  final CustomLogger logger = CustomLogger('PendingPhotoLibraryProvider');

  PendingPhotoLibraryProvider({super.key});

  @override
  Widget build(BuildContext context) {


    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigateCoreBloc>(
          create: (context) => NavigateCoreBloc(
            coreFetchService: coreLocator<CoreFetchService>(),  // Access CoreFetchService via GetIt
            coreSaveService: coreLocator<CoreSaveService>(),    // Access CoreSaveService via GetIt
          ),
        ),
        BlocProvider<PhotoLibraryBloc>(
          create: (context) => PhotoLibraryBloc(
            photoLibraryService: PhotoLibraryService(
              coreLocator<CoreSaveService>(),
            ),
          ),
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            logger.d('Creating TutorialBloc with core services');
            return TutorialBloc(
              coreFetchService: coreLocator<CoreFetchService>(),
              coreSaveService: coreLocator<CoreSaveService>(),
            );
          },
        ),
      ],
      child: const PendingPhotoLibraryScreen(),
    );
  }
}
