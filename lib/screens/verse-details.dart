import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/models/verse.dart';
import 'package:draw_near/services/verse-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

class VerseDetails extends StatefulWidget {
  final String recordId;
  const VerseDetails(this.recordId) : super();

  @override
  State<VerseDetails> createState() => _VerseDetailsState();
}

class _VerseDetailsState extends State<VerseDetails> {
  late Verse verse;

  @override
  void initState() {
    verse = VerseService.instance.getVerse(widget.recordId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("bible_por".tr()),
        ),
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

              Text("bible_por".tr(), style: GoogleFonts.abrilFatface(fontSize: 32),),
              SizedBox(height: 24,),
              Text(verse.fullVerse, style: GoogleFonts.montserrat( fontSize: 16, fontWeight: FontWeight.w300, height: 1.5),)
            ],
          ),

        ),
      )
    );
  }
}


