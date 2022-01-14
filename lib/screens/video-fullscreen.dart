import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: widget.controller,
        controlsTimeOut: Duration(seconds: 1),
        showVideoProgressIndicator: true,
        // bottomActions: [
        //   const SizedBox(width: 14.0),
        //   CurrentPosition(),
        //   const SizedBox(width: 8.0),
        //   ProgressBar(
        //     isExpanded: true,
        //     colors: ProgressBarColors(),
        //   ),
        //   RemainingDuration(),
        //   const PlaybackSpeedButton(),
        //   IconButton(
        //       icon: Icon(Icons.fullscreen_exit, color: Colors.white),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       }),
        // ],
      ),
      builder: (context, player) => SafeArea(child: player),
    );
  }
}
