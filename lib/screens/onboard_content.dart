
class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent({required this.image,required this.title, required this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      title: 'About Draw Near',
      image: 'assets/images/image_1.png',
      description: "The draw near family daily devotion App is the right choice for any family that likes to reinforce Godly values in everyday life. Begin each day with encouraging and enlightening words straight from Scripture. Impacting Our World! Enriching Faith!! Inspiring hope!!! These devotions are simply about promises and the life that flows from them. We hope these devotions can be a blessing to you, whatever your circumstance."
    ),
  OnboardingContent(
      title: 'About Bible portion',
      image: 'assets/images/image_2.png',
      description: "Psalm 119:105 says, 'Your word is a lamp to my feet and a light for my path.' The success of any family devotion depends on the truth that is drawn from the scriptures. Reading the Bible portion helps us to achieve a deeper connection and relationship with God as a family. The inspired word of God, transforms life’s and encourages families to become more Christ-like. Meditating on God’s word is an excellent way of building spiritually-strong families."

  ),
  OnboardingContent(
      title: 'About Prayer',
      image: 'assets/images/image_3.png',
    description: "Jesus laid out what real true worship is, first it's to worship God in spirit and truth. True worship must be “in spirit,” that is, engaging the whole heart. If there is no real passion for God, there is no worship in spirit. Real worship involves what Romans says; “your body as a living sacrifice.” Worship can shift our mindset and change our perspective on the world. Worship heals wounds and breaks generational curses. Worship, lets us hear God and lets God hear us."


  ),
];