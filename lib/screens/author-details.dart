import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw_near/models/author.dart';
import 'package:draw_near/services/author-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';

class AuthorDetails extends StatefulWidget {
  final String recordId;
  const AuthorDetails(this.recordId) : super();

  @override
  State<AuthorDetails> createState() => _AuthorDetailsState();
}

class _AuthorDetailsState extends State<AuthorDetails> {
  late Author author;

  @override
  void initState() {
    author = AuthorService.instance.getAuthor(widget.recordId);
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

                 Container(
                   height: 250,
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: CachedNetworkImageProvider(author.photo[0]['url']),fit: BoxFit.cover)),
                   //child: CachedNetworkImage(imageUrl: author.photo[0]['url'],),
                 ),
            SizedBox(height: 16,),
            Text(
              author.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                textStyle: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              author.description,
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w300, height: 1.5),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    ));
  }
}
