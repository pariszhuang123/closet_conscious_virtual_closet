import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'outfit_wear_screen.dart';
import 'package:get_it/get_it.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';

class OutfitWearProvider extends StatelessWidget {
  final String outfitId;

  const OutfitWearProvider({
    super.key,
    required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final outfitFetchService = GetIt.instance<OutfitFetchService>();

        // Retrieve the OutfitSaveService from GetIt
        final outfitSaveService = GetIt.instance<OutfitSaveService>();  // Add this line

        // Pass the authBloc, photoCaptureService, outfitFetchService, and outfitSaveService to the OutfitWearBloc
        return OutfitWearBloc(
          outfitFetchService: outfitFetchService,
          outfitSaveService: outfitSaveService,  // Provide the required argument
        );
      },
      child: OutfitWearScreen(
        outfitId: outfitId,
      ),
    );
  }
}
