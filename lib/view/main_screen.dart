import 'package:flutter/material.dart';
import 'package:my_video_player/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'video_player_view.dart';
import 'video_picker_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const VideoPlayerView(),
    const VideoPickerView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: _screens[value.selectedIndex], // Show selected screen
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value.selectedIndex,
            onTap: value.onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_fill),
                label: 'Player',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_library),
                label: 'Select Video',
              ),
            ],
          ),
        );
      },
    );
  }
}
