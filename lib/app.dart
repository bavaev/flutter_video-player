import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VideoPlayerController _controller;
  int position = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4');

    _controller.setLooping(true);
    _controller.initialize().then((value) => setState(() {}));
    _controller.play();
    _controller.addListener(() => _controller.value.isInitialized ? updateSeeker() : null);
  }

  Future<void> updateSeeker() async {
    final newPosition = await _controller.position;
    setState(() {
      position = newPosition!.inMilliseconds.toInt();
    });
  }

  String _position() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(position ~/ 3600000);
    String twoDigitMinutes = twoDigits(position ~/ 60000);
    String twoDigitSeconds = twoDigits(position ~/ 1000);
    if (twoDigitHours != '00') {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else if (twoDigitMinutes != '00') {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return twoDigitSeconds;
    }
  }

  String _totalDuration(int duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration ~/ 3600000);
    String twoDigitMinutes = twoDigits(duration ~/ 60000);
    String twoDigitSeconds = twoDigits(duration ~/ 10000);
    if (twoDigitHours != '00') {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else if (twoDigitMinutes != '00') {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return twoDigitSeconds;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double durationVideo = _controller.value.duration.inMilliseconds.toDouble();
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
            Row(
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
                    Duration targetPosition = currentPosition - const Duration(seconds: 10);
                    _controller.seekTo(targetPosition);
                    setState(() {});
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
                          setState(() {});
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
                          setState(() {});
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
                    Duration targetPosition = currentPosition + const Duration(seconds: 10);
                    _controller.seekTo(targetPosition);
                    setState(() {});
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    value: position.toDouble(),
                    max: durationVideo + 10,
                    onChanged: (double value) {
                      position = value.toInt();
                      _controller.seekTo(Duration(milliseconds: position));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _position(),
                        style: const TextStyle(fontSize: 40),
                      ),
                      Text(
                        _totalDuration(durationVideo.toInt()),
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
