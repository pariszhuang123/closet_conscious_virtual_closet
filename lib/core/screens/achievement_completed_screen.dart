import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart'; // Confetti package
import '../../generated/l10n.dart';

class AchievementScreen extends StatefulWidget {
  final String achievementKey;  // Used for localized achievement name
  final String achievementUrl;
  final String nextRoute;

  const AchievementScreen({
    super.key,
    required this.achievementKey,  // Added for localization
    required this.achievementUrl,
    required this.nextRoute,
  });

  @override
  AchievementScreenState createState() => AchievementScreenState();
}

class AchievementScreenState extends State<AchievementScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();  // Start confetti celebration immediately

    // Set a timer to navigate to the next route after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use the achievementKey to retrieve localized achievement message
    String achievementTitle;
    String achievementMessage;

    switch (widget.achievementKey) {
      case 'all_clothes_worn':
        achievementTitle = S.of(context).allClothesWornAchievement;
        achievementMessage = S.of(context).allClothesWornAchievementMessage;
        break;
      case 'closet_uploaded':
        achievementTitle = S.of(context).closetUploadAchievement;
        achievementMessage = S.of(context).closetUploadAchievementMessage;
        break;
      case 'no_new_clothes_1215':
        achievementTitle = S.of(context).noNewClothes1215Achievement;
        achievementMessage = S.of(context).noNewClothes1215AchievementMessage;
        break;
      case 'no_new_clothes_1575':
        achievementTitle = S.of(context).noNewClothes1575Achievement;
        achievementMessage = S.of(context).noNewClothes1575AchievementMessage;
        break;
      case 'no_new_clothes_225':
        achievementTitle = S.of(context).noNewClothes225Achievement;
        achievementMessage = S.of(context).noNewClothes225AchievementMessage;
        break;
      case 'no_new_clothes_405':
        achievementTitle = S.of(context).noNewClothes405Achievement;
        achievementMessage = S.of(context).noNewClothes405AchievementMessage;
        break;
      case 'no_new_clothes_630':
        achievementTitle = S.of(context).noNewClothes630Achievement;
        achievementMessage = S.of(context).noNewClothes630AchievementMessage;
        break;
      case 'no_new_clothes_90':
        achievementTitle = S.of(context).noNewClothes90Achievement;
        achievementMessage = S.of(context).noNewClothes90AchievementMessage;
        break;
      case 'no_new_clothes_900':
        achievementTitle = S.of(context).noNewClothes900Achievement;
        achievementMessage = S.of(context).noNewClothes900AchievementMessage;
        break;
      case '1st_selfie_taken':
        achievementTitle = S.of(context).firstSelfieTakenAchievement;
        achievementMessage = S.of(context).firstSelfieTakenAchievementMessage;
        break;
      case '1st_outfit_created':
        achievementTitle = S.of(context).firstOutfitCreatedAchievement;
        achievementMessage = S.of(context).firstOutfitCreatedAchievementMessage;
        break;
      case '1st_item_gifted':
        achievementTitle = S.of(context).firstItemGiftedAchievement;
        achievementMessage = S.of(context).firstItemGiftedAchievementMessage;
        break;
      case '1st_item_pic_edited':
        achievementTitle = S.of(context).firstItemPicEditedAchievement;
        achievementMessage = S.of(context).firstItemPicEditedAchievementMessage;
        break;
      case '1st_item_sold':
        achievementTitle = S.of(context).firstItemSoldAchievement;
        achievementMessage = S.of(context).firstItemSoldAchievementMessage;
        break;
      case '1st_item_swap':
        achievementTitle = S.of(context).firstItemSwapAchievement;
        achievementMessage = S.of(context).firstItemSwapAchievementMessage;
        break;
      case '1st_item_uploaded':
        achievementTitle = S.of(context).firstItemUploadAchievement;
        achievementMessage = S.of(context).firstItemUploadAchievementMessage;
        break;
      default:
        achievementTitle = S.of(context).defaultAchievementTitle; // Fallback if none match
        achievementMessage = S.of(context).defaultAchievementMessage;
        break;
    }

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          // Do nothing, effectively preventing the back action
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Confetti widget for celebration
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Colors.blue, Colors.lightGreenAccent, Colors.teal],
              numberOfParticles: 30,
            ),
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Congratulatory text
                    Text(
                      S.of(context).congratulations,
                      style: theme.textTheme.displayLarge,
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Achievement Title
                    Text(
                      achievementTitle,  // Localized achievement title based on key
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),

                    // Celebration animation
                    SizedBox(
                      height: 75,
                      child: Lottie.asset('assets/lottie/tasty.json'),
                    ),
                    const SizedBox(height: 20),

                    // Achievement Badge or Image
                    SizedBox(
                      height: 100,
                      child: Image.network(
                        widget.achievementUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Achievement Message
                    Text(
                      achievementMessage,  // Localized achievement message based on key
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
