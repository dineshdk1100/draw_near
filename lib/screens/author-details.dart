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
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        padding: EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [

                 CircleAvatar(
                  minRadius: 80,
                  maxRadius: 120,
                  backgroundImage: NetworkImage(author.photo[0]['url'], ) ,
                ),
            SizedBox(height: 16,),
            Text(
              author.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.kavivanar(
                textStyle: Theme.of(context).textTheme.headline4,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              author.description,
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    ));
  }
}
