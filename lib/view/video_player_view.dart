import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Center(
        child: Consumer<VideoProvider>(
          builder: (context, videoProvider, child) {
            return videoProvider.video == null
                ? const Text("Select A Video To Play it")
                : videoProvider.enState == EnState.busy
                    ? const CircularProgressIndicator()
                    : (videoProvider.videoController.chewieController != null &&
                            videoProvider.videoController.videoPlayerController!
                                .value.isInitialized)
                        ? GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              // Adjust video position (forward/backward seek)
                              final position = videoProvider.videoController
                                  .videoPlayerController?.value.position;
                              if (position != null) {
                                videoProvider
                                    .videoController.videoPlayerController
                                    ?.seekTo(position +
                                        Duration(
                                            seconds: details.primaryDelta! > 0
                                                ? 5
                                                : -5));
                              }
                            },
                            onVerticalDragUpdate: (details) {
                              // Adjust brightness or volume based on drag direction
                            },
                            child: Chewie(
                                controller: videoProvider
                                    .videoController.chewieController!),
                          )
                        : const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
