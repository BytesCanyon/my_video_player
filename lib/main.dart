import 'package:flutter/material.dart';
import 'package:receive_intent/receive_intent.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(VideoPlayerApp());
}

class VideoPlayerApp extends StatefulWidget {
  const VideoPlayerApp({super.key});

  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  String? videoUrl;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _handleIntent();
  }

  Future<void> _handleIntent() async {
    final intent = await ReceiveIntent.getInitialIntent();
    if (intent != null && intent.data != null) {
      setState(() {
        videoUrl = intent.data;
        _initializeVideoPlayer();
      });
    }
  }

  void _initializeVideoPlayer() {
    if (videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl!))
        ..initialize().then((_) {
          setState(() {});
          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoPlay: true,
            looping: false,
          );
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("MP4 Video Player")),
        body: Center(
          child: videoUrl == null
              ? Text("No video received")
              : _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
