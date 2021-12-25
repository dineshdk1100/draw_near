import 'package:draw_near/models/song.dart';
import 'package:draw_near/services/song-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongDetails extends StatefulWidget {
  final String recordId;
  const SongDetails(this.recordId) : super();

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  late Song song;

  @override
  void initState() {
    song = SongService.instance.getSong(widget.recordId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          padding: EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              // CircleAvatar(
              //   child: OctoImage.fromSet(
              //     fit: BoxFit.cover,
              //     image: CachedNetworkImageProvider(
              //         carouselImageUrls[itemIndex]),
              //     octoSet: OctoSet.circularIndicatorAndIcon(
              //         showProgress: true),
              //   ),
              // ),

              Text('song'.tr() +  song.number ,style: GoogleFonts.abrilFatface(
                textStyle: Theme.of(context).textTheme.headline4,
              ),),
              SizedBox(height: 24,),
              Text(song.body, style: GoogleFonts.lora(fontStyle: FontStyle.italic, fontSize: 20, height: 1.5),)
            ],
          ),

        ),
      )
    );
  }
}


