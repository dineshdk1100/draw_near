import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draw_near/models/devotion.dart';
import 'package:draw_near/services/carousel-service.dart';
import 'package:draw_near/services/devotion-service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> carouselImageUrls = [
    'https://images.pexels.com/photos/1005417/pexels-photo-1005417.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/589802/pexels-photo-589802.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
  ];
  DevotionService _devotionService = DevotionService();
  late Devotion devotion;
  _HomePageState() {
    getCarouselImages().then((urls) => {});
    getDevotionForToday();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('welcome'.tr(namedArgs: {'name': 'Jothish'})),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: onMorePressed, icon: Icon(Icons.more_vert_rounded))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: width,
                height: height * 0.22,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                bottom: -70.0,
                child: Container(
                  width: width,
                  height: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: CarouselSlider.builder(
                    itemCount: carouselImageUrls.length,
                    options: CarouselOptions(

                        autoPlay: true,
                        enlargeCenterPage: true),
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Card(
                      clipBehavior: Clip.antiAlias,
                      child: OctoImage.fromSet(
                        width: width,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            carouselImageUrls[itemIndex]),
                        octoSet: OctoSet.circularIndicatorAndIcon(
                            showProgress: true),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.local_library_outlined),
                    title: Text(devotion.title),
                    subtitle: Text('devotion_day'.tr()),
                  ),
                  Divider(),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(devotion.body,
                        textAlign: TextAlign.justify,
                        maxLines: 8,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  TextButton(
                      onPressed: navigateToDevotionPage(),
                      child: Text('READ MORE'))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.accessibility_new_outlined),
                title: Text(devotion.title),
                subtitle: Text('theme_month'.tr()),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onMorePressed() {}

  getDevotionForToday() {
    //devotion = _devotionService.getDevotionsForDate(DateTime.now());
    devotion = Devotion(
        DateTime.now(),
        'Power of Compassion',
        ' ',
        ' ',
        ' ',
        ' ',
        'Truth for Today: Whenever our Lord Jesus Christ was moved with compassion, He did something miraculous! The scene of the widow weeping for the loss of her son moved the Lord with compassion which compelled Him into action and therefore He raised the dead man alive and presented him to his mother. Fear came upon all who witnessed this great miracle of a dead man coming back to life. The true definition of compassion involves a tangible expression of love for those who are suffering. It gives us the ability to understand someone’s struggle and it creates a desire to take action to alleviate their suffering. It is the most powerful force in the world; it benefits both those who receive it and those who share it. Christ when He walked on this earth was filled with compassion for the people, and He wants us also to feel the same divine power. Real life Events: Ida Scudder the woman who grew up in India and couldn’t wait to leave, one night witnessed the death of three women in labor as their husbands refused the help of her father who was a doctor due to the social taboo that existed at that time. Seeing the plight of the women folks of our country, Ida was moved with compassion and so pursued medical studies abroad. She came back to India and served the Lord by founding a teaching hospital, in which women were admitted and trained in medical studies. She brought a huge change in the lives of so many women. Adopt and Apply: Developing a heart for compassion begins in families. When parents lead a compassionate life, children will naturally witness the powerful changes that this attribute brings in their lives and will assume its importance for their lives. Let the power of compassion flow from our families to the society thereby bringing glory to His kingdom.',
        ' ',
        ' ',
        Quote('', ''),
        ' ',
        DateTime.now());
  }

  navigateToDevotionPage() {}
}
