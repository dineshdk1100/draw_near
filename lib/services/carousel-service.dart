import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_near/models/carousel_image.dart';
import 'package:draw_near/services/user-service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CarouselImageService {
  var box = Hive.box('draw_near');
  late List carouselImages;

  CarouselImage _carouselImage = CarouselImage("rec", [
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
  ]);

  static final CarouselImageService instance = CarouselImageService._internal();

  CarouselImageService._internal() {
    getCarouselImagesForCurrentLocale();
  }

  getCarouselImagesForCurrentLocale() {
    this.carouselImages = box
        .get('carouselImages_${UserService.instance.locale}', defaultValue: []);
  }

  List getCarouselImages() {
    //return _carouselImage;
    return carouselImages;
  }

  void saveCarouselImage(Map<String, dynamic>? data) {
    carouselImages = data?['images'];
  }

  void saveCarouselImages(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    CarouselImageService.instance.saveCarouselImage(snapshot.data());
    box.put('carouselImages_${UserService.instance.locale}', carouselImages);
  }
}
