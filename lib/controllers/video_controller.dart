import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:hive/hive.dart';

class VideoController {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Timer? _progressTimer;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  ChewieController? get chewieController => _chewieController;

  Future<void> initializeVideo(
      String url, String videoUid, Function notifyListeners) async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoPlayerController!.initialize();

    // Get last saved position from Hive
    final box = await Hive.openBox('video_progress');
    int lastPosition = box.get(videoUid, defaultValue: 0);

    // Resume from last saved position
    _videoPlayerController!.seekTo(Duration(seconds: lastPosition));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
    );

    // Start saving progress every 5 seconds
    _startSavingProgress(videoUid);

    notifyListeners();
  }

  void _startSavingProgress(String videoUid) {
    _progressTimer?.cancel(); // Cancel any existing timer

    _progressTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isPlaying) {
        final currentPosition =
            _videoPlayerController!.value.position.inSeconds;

        // Save progress to Hive
        final box = await Hive.openBox('video_progress');
        await box.put(videoUid, currentPosition);
      }
    });
  }

  void dispose() {
    _progressTimer?.cancel(); // Stop auto-saving
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
  }
}
