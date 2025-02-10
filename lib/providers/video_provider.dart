import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:receive_intent/receive_intent.dart';
import '../models/video_model.dart';
import '../controllers/video_controller.dart';

enum EnState { busy, idle }

class VideoProvider extends ChangeNotifier {
  VideoModel? _video;
  final VideoController _videoController = VideoController();
  int selectedIndex = 0;
  EnState enState = EnState.idle;

  VideoModel? get video => _video;
  VideoController get videoController => _videoController;

  void setState(EnState newState) {
    enState = newState;
    notifyListeners();
  }

  Future<void> handleIntent() async {
    setState(EnState.busy);
    final intent = await ReceiveIntent.getInitialIntent();
    String? videoUrl = "";
    if (intent != null) {
      videoUrl = intent.data;
    }
    if (videoUrl != null) {
      _video = VideoModel(videoUid: videoUrl, url: videoUrl);
      await _initializeAndResumeVideo(videoUrl);
    }
  }

  Future<void> handleLocalVideo(
    String filePath,
  ) async {
    setState(EnState.busy);
    _video = VideoModel(videoUid: filePath, url: filePath);

    await _initializeAndResumeVideo(filePath.toString());
  }

  Future<void> _initializeAndResumeVideo(String id) async {
    if (_video == null) return;

    await _videoController.initializeVideo(
      _video!.url,
      id,
      notifyListeners,
    );
    setState(EnState.idle);
  }

  void saveVideoProgress() {
    if (_video == null || _videoController.videoPlayerController == null) {
      return;
    }

    final box = Hive.box('videoBox');
    int position =
        _videoController.videoPlayerController!.value.position.inSeconds;

    box.put('${_video!.videoUid}_position', position);
  }

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    saveVideoProgress();
    _videoController.dispose();
    super.dispose();
  }
}
