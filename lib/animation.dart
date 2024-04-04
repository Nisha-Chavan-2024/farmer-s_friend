
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  late Future<void> _initializeVideoPlayerFuture;
  late VideoPlayerController _videoPlayerController;
  late VideoPlayerController _secondAnimationController;

  String path = "video/main_animation.mp4";
  String path2 = "video/arrow_animation.mp4";

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _secondAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _videoPlayerController = VideoPlayerController.asset(path);
    _secondAnimationController = VideoPlayerController.asset(path2);

    await Future.wait([
      _videoPlayerController.initialize(),
      _secondAnimationController.initialize(),
    ]);

    _videoPlayerController.setLooping(false);
    _videoPlayerController.play();

    _secondAnimationController.setLooping(false);
    _secondAnimationController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 350,
                      height: 350,
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: AspectRatio(
                    aspectRatio: _secondAnimationController.value.aspectRatio,
                    child: VideoPlayer(_secondAnimationController),
                  ),
                ),
              ],
            );
          } else {
            // If the VideoPlayerControllers are still initializing, show a
            // loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
