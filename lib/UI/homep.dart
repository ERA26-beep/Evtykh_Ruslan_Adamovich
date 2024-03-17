import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});


  @override
  _VideoAppState createState() => _VideoAppState();
}


class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    _initializePlay();
    super.initState();
  }

  void _nextVideoPlay(String videoPath) {
    ///
    _startPlay(videoPath);
  }

  Future<void> _startPlay(String videoPath) async {
    await _clearPrevious().then((_) {
      _initializePlay(videoPath: videoPath);
    });
  }

  Future<bool> _clearPrevious() async {
    await _videoController.pause();
    _videoController.notifyListeners();
    _videoController.dispose();
    return true;
  }

  Future<void> _initializePlay({String? videoPath}) async {
    _videoController =
    VideoPlayerController.network(videoPath ?? AppResource.videos.first)
      ..initialize().then((_) {
        _videoController.play();
        setState(() {});
      });
  }

  int videoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ВКурсе',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Профиль ВКурсе", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10,),
            Text("Имя: Шрек, Возраст: 38 лет, Семейное положение: Женат"),
            Center(
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
                  : Container(),
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    videoIndex = 0;
                    _nextVideoPlay(
                        AppResource.videos[videoIndex % AppResource.videos.length]);
                  },
                  child: const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 40.0),
                ),

                ElevatedButton(
                  onPressed: () {
                    videoIndex = 1;
                    _nextVideoPlay(
                        AppResource.videos[videoIndex % AppResource.videos.length]);
                  },
                  child: const Icon(
                      Icons.disabled_by_default_outlined,
                      color: Colors.redAccent,
                      size: 40.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}

class AppResource {
  static List<String> videos = [
    'assets/video/shrek.mp4',
    'assets/video/shrekRev.mp4',
  ];
}