import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'handles.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VideoPlayerController _controller;
  double durationVideo = 0;
  bool playing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://media.istockphoto.com/videos/sekapark-sunset-video-izmit-city-turkey-video-id862642892');

    _controller.setLooping(true);
    _controller.initialize().then((value) => setState(() {}));
    _controller.play();
    _controller.addListener(() {
      _controller.value.isInitialized ? updateSeeker() : null;
      durationVideo = _controller.value.duration.inMilliseconds.toDouble();
    });
  }

  Future<void> updateSeeker() async {
    final newPosition = await _controller.position;
    setState(() {
      position = newPosition!.inMilliseconds.toInt();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Video Player'),
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const SizedBox(),
            Opacity(
              opacity: _controller.value.isPlaying ? 0.2 : 1.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.replay_10,
                      size: 70,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Duration currentPosition = _controller.value.position;
                      Duration targetPosition = currentPosition - const Duration(milliseconds: 10000);
                      _controller.seekTo(targetPosition);
                    },
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  _controller.value.isPlaying
                      ? IconButton(
                          icon: const Icon(
                            Icons.pause,
                            size: 70,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _controller.pause();
                          },
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            size: 80,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _controller.play();
                          },
                        ),
                  const SizedBox(
                    width: 40,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.forward_10,
                      size: 70,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Duration currentPosition = _controller.value.position;
                      Duration targetPosition = currentPosition + const Duration(milliseconds: 10000);
                      _controller.seekTo(targetPosition);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    value: position.toDouble(),
                    max: durationVideo,
                    onChanged: (double value) {
                      position = value.toInt();
                      _controller.seekTo(Duration(milliseconds: position));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentPosition(),
                        style: const TextStyle(fontSize: 40),
                      ),
                      Text(
                        totalDuration(durationVideo.toInt()),
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
