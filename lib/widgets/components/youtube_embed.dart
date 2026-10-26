import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const _origemApp = 'https://com.example.zetesis';

class YoutubeEmbed extends StatefulWidget {
  final String videoId;

  const YoutubeEmbed({super.key, required this.videoId});

  @override
  State<YoutubeEmbed> createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<YoutubeEmbed> {
  late final _controller = YoutubePlayerController.fromVideoId(
    videoId: widget.videoId,
    params: const YoutubePlayerParams(
      origin: _origemApp,
      showFullscreenButton: true,
    ),
  );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      YoutubePlayer(controller: _controller, aspectRatio: 16 / 9);
}
