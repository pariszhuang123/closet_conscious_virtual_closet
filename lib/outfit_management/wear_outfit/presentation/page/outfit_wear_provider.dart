import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'outfit_wear_view.dart';
import '../../../../core/photo/usecase/photo_capture_service.dart';
import 'package:get_it/get_it.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';

class OutfitWearProvider extends StatelessWidget {
  final DateTime date;
  final String outfitId;
  final ThemeData myOutfitTheme;

  const OutfitWearProvider({
    super.key,
    required this.date,
    required this.outfitId,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Retrieve the existing AuthBloc from the context
        // Initialize PhotoCaptureService correctly
        final photoCaptureService = PhotoCaptureService();

        // Retrieve the OutfitFetchService from GetIt
        final outfitFetchService = GetIt.instance<OutfitFetchService>();

        // Retrieve the OutfitSaveService from GetIt
        final outfitSaveService = GetIt.instance<OutfitSaveService>();  // Add this line

        // Pass the authBloc, photoCaptureService, outfitFetchService, and outfitSaveService to the OutfitWearBloc
        return OutfitWearBloc(
          photoCaptureService: photoCaptureService,
          outfitFetchService: outfitFetchService,
          outfitSaveService: outfitSaveService,  // Provide the required argument
        );
      },
      child: OutfitWearView(
        date: date,
        outfitId: outfitId,
        myOutfitTheme: myOutfitTheme,
      ),
    );
  }
}
