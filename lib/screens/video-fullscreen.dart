import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoFullScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  VideoFullScreen(this.controller);

  @override
  _VideoFullScreenState createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  @override
  void initState() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

    super.initState();
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
      child: AspectRatio(aspectRatio: 16/9,
        child: YoutubePlayer(
          controller: widget.controller,
          controlsTimeOut: Duration(seconds: 1),
          showVideoProgressIndicator: true,
          bottomActions: [
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
              colors: ProgressBarColors(),
            ),
            RemainingDuration(),
            const PlaybackSpeedButton(),
            IconButton(icon: Icon(Icons.fullscreen_exit, color: Colors.white), onPressed: () {widget.controller.Navigator.pop(context);}),
          ],
        ),
      ),
    ),);
  }
}
