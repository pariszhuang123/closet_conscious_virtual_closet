import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeVideoPageItem extends StatelessWidget {
  final int index;
  final Map<int, YoutubePlayerController> controllers;
  final Future<YoutubePlayerController> Function(int) loadController;

  const YouTubeVideoPageItem({
    super.key,
    required this.index,
    required this.controllers,
    required this.loadController,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<YoutubePlayerController>(
      future: loadController(index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return YoutubePlayerControllerProvider(
            controller: snapshot.data!,
            child: YoutubePlayer(controller: snapshot.data!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
