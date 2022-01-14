import 'package:draw_near/models/song.dart';
import 'package:draw_near/screens/video-fullscreen.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetails extends StatefulWidget {
  final String recordId;
  const SongDetails(this.recordId) : super();

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  late Song song;
  late String videoId;
  late YoutubePlayerController _controller;
  @override
  void initState() {
    song = SongService.instance.getSong(widget.recordId);
    initializeVideoController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('song'.tr()),
        ),
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            controlsTimeOut: Duration(seconds: 10),
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
              IconButton(icon: Icon(Icons.fullscreen, color: Colors.white,), onPressed: ()=> pushNewScreen(
                context,
                screen: VideoFullScreen(_controller),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),),
            ],
          ),
          builder: (context, player) => SizedBox.expand(
            child: Container(
              //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              //padding: EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'song'.tr() + ' ' + song.number,
                      style: GoogleFonts.abrilFatface(
                        textStyle: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  player,
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      song.body,
                      style: GoogleFonts.lora(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          height: 1.5),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  initializeVideoController() {
    videoId = YoutubePlayer.convertUrlToId(song.videoLink ?? "") ?? "";
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      controlsVisibleAtStart: true,

        //enableCaption: true,
      ),
    );

    print(videoId); // BBAyRBTfsOU
  }
}
