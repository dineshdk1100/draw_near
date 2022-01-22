import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/author.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthorService {
  var box = Hive.box('draw_near');
  late Map<String, dynamic> authorsMap;

  Author _author = Author(
      "rec",
      "Ruby Raja",
      'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
      [
        {
          "id": "attLRT8AgGmcRdHHM",
          "width": 1152,
          "height": 1152,
          "url":
              "https://dl.airtable.com/.attachments/04b89561e5ad56d2f26f7c401ad87055/0ac78ccc/American_Crew_-_Official_Supplier_to_Men",
          "filename": "American_Crew_-_Official_Supplier_to_Men",
          "size": 116815,
          "type": "image/jpeg",
          "thumbnails": {
            "small": {
              "url":
                  "https://dl.airtable.com/.attachmentThumbnails/449f9dcaad9e48da6f33d026bd01fc64/a5fb4863",
              "width": 36,
              "height": 36
            },
            "large": {
              "url":
                  "https://dl.airtable.com/.attachmentThumbnails/4969035ecc995bf6f6f1fc312d2faaf3/b5e7a956",
              "width": 512,
              "height": 512
            },
            "full": {
              "url":
                  "https://dl.airtable.com/.attachmentThumbnails/6b2ab79dbb792d0ba3eb48341d01ca55/fbab98b7",
              "width": 3000,
              "height": 3000
            }
          }
        }
      ],
      12345678);

  static final AuthorService instance = AuthorService._internal();

  AuthorService._internal() {
    getAuthorsForCurrentLocale();
  }

  getAuthorsForCurrentLocale() {
    this.authorsMap = jsonDecode(
        box.get('authors_${UserService.instance.locale}', defaultValue: '{}'));
  }

  Author getAuthor(String recordId) {
    if (!authorsMap.containsKey(recordId)) throw AuthorNotFoundException();
    return Author.fromJson(authorsMap[recordId]);
  }

  void saveAuthor(String recordId, Map<String, dynamic> data) {
    authorsMap[recordId] = data;
  }

  void saveAuthors(QuerySnapshot<Map<String, dynamic>> snapshots) {
    snapshots.docs.forEach((doc) {
      //print(doc.data());
      AuthorService.instance.saveAuthor(doc.id, doc.data());
    });
    box.put('authors_${UserService.instance.locale}', jsonEncode(authorsMap));
  }
}

class AuthorNotFoundException implements Exception {}
