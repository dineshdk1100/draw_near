import 'package:draw_near/models/song.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            showVideoProgressIndicator: true,
            progressIndicatorColor: Theme.of(context).toggleableActiveColor,
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
      ),
    );

    print(videoId); // BBAyRBTfsOU
  }
}
