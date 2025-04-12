import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final String videoId = widget.youtubeIds.first;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true, // ✅ Start playing when ready
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: YoutubePlayerControllerProvider(
            controller: _controller,
            child: YoutubePlayer(controller: _controller),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.descriptions.first,
          style: widget.theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
