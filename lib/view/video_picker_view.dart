import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';

class VideoPickerView extends StatelessWidget {
  const VideoPickerView({super.key});

  Future<void> _pickVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      if (context.mounted) {
        Provider.of<VideoProvider>(context, listen: false)
            .handleLocalVideo(filePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Video")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickVideo(context),
          child: const Text("Choose Video"),
        ),
      ),
    );
  }
}
