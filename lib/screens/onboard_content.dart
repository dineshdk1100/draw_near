
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
      description: "The draw near family daily devotion App is the right choice for any family that likes to reinforce Godly values in everyday life. Each daily devotion includes a Bible reading portion and song which are available at a touch. The daily devotion starts with a Bible verse to meditate, truth from the scripture that builds family values, relevant real-life situation that helps families to relate to their ongoing situation in life, followed by guidance on how to adopt and apply it in their lives. At the end of each reading, the reflect and respond invites us to discuss and find practical solutions for our life’s problems."
  ),
  OnboardingContent(
      title: 'About Bible portion',
      image: 'assets/images/image_2.png',
      description: "Psalm 119:105 says, Your word is a lamp to my feet and a light for my path. The success of any family devotion depends on the truth that is drawn from the scriptures. Reading the Bible portion helps us to achieve a deeper connection and relationship with God as a family. You can start the family devotional by reading the given Bible portion with a click. The inspired word of God, transforms life and encourages families to become more Christ-like. Meditating on God’s word is an excellent way of building spiritually-strong families. In the Bible, God reveals himself to us, we discover His nature, character, love, justice, forgiveness, and truth."
  ),
  OnboardingContent(
      title: 'About Prayer',
      image: 'assets/images/image_3.png',
      description: "O sing unto the LORD a new song: sing unto the LORD, all the earth. (Psalm 96:1). Singing together  as a family is one of the greatest gift God has given to His children. One thing that is lacking today in Christian homes is the ability to sing together as a family. When families realize the importance of worshipping the Lord in true spirit through songs of praise they will invite the presence of God in their heart and in their home. Families that worship the Lord together foster richer spiritual lives, deeper and closer family bonds. As a family together you can sing the songs given in the daily portion by opening the link and be blessed."
  ),
];