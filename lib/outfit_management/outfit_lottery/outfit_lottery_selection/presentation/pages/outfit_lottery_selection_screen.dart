import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../widgets/occasion_season_selector.dart';
import '../../../../../core/filter/presentation/widgets/tab/single_selection_tab/all_closet_toggle.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/utilities/logger.dart';

class OutfitLotterySelectionScreen extends StatefulWidget {
  const OutfitLotterySelectionScreen({super.key});

  @override
  State<OutfitLotterySelectionScreen> createState() =>
      _OutfitLotterySelectionScreenState();
}

class _OutfitLotterySelectionScreenState
    extends State<OutfitLotterySelectionScreen> {
  final CustomLogger logger = CustomLogger('OutfitLotterySelectionScreen');

  String? selectedOccasion;
  String? selectedSeason;
  bool isAllCloset = true;

  void _onSubmit() {
    logger.d('Submitting outfit lottery with '
        'occasion: $selectedOccasion, season: $selectedSeason, useAllClosets: $isAllCloset');

    context.pushNamed(
      AppRoutesName.outfitLotteryResultProvider,
      extra: {
        'occasion': selectedOccasion,
        'season': selectedSeason,
        'useAllClosets': isAllCloset,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).outfitLotteryTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OccasionSeasonSelector(
              selectedOccasion: selectedOccasion,
              selectedSeason: selectedSeason,
              onOccasionChanged: (val) {
                logger.d('Occasion changed to: $val');
                setState(() => selectedOccasion = val);
              },
              onSeasonChanged: (val) {
                logger.d('Season changed to: $val');
                setState(() => selectedSeason = val);
              },
            ),
            const SizedBox(height: 16),
            AllClosetToggle(
              isAllCloset: isAllCloset,
              onChanged: (value) {
                logger.d('AllClosetToggle changed to: $value');
                setState(() => isAllCloset = value);
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: Text(S.of(context).generateOutfit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
