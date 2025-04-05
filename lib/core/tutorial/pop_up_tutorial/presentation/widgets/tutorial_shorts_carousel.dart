import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../widgets/layout/page_indicator.dart';

class TutorialShortsCarousel extends StatefulWidget {
  final List<String> youtubeIds;
  final List<String> descriptions;
  final ThemeData theme;

  const TutorialShortsCarousel({
    super.key,
    required this.youtubeIds,
    required this.descriptions,
    required this.theme,
  });

  @override
  State<TutorialShortsCarousel> createState() => _TutorialShortsCarouselState();
}

class _TutorialShortsCarouselState extends State<TutorialShortsCarousel> {
  late PageController _pageController;
  int currentIndex = 0;
  final Map<int, YoutubePlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    for (int i = 0; i < widget.youtubeIds.length; i++) {
      _controllers[i] = YoutubePlayerController.fromVideoId(
        videoId: widget.youtubeIds[i],
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: false,
        ),
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() => currentIndex = index);

    for (int i = 0; i < widget.youtubeIds.length; i++) {
      final controller = _controllers[i];
      if (controller != null) {
        if ((i - index).abs() <= 1) {
          controller.playVideo();
        } else {
          controller.pauseVideo();
          controller.seekTo(seconds: 0);
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.youtubeIds.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              if ((index - currentIndex).abs() <= 1) {
                return YoutubePlayerControllerProvider(
                  controller: _controllers[index]!,
                  child: YoutubePlayer(
                    controller: _controllers[index]!,
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        const SizedBox(height: 10),

        // ✅ Add the PageIndicator widget here
        PageIndicator(
          itemCount: widget.youtubeIds.length,
          currentIndex: currentIndex,
          theme: widget.theme,
        ),

        const SizedBox(height: 10),
        Text(
          widget.descriptions[currentIndex],
          style: widget.theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
