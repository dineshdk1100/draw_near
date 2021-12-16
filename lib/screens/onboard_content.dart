
class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent({required this.image,required this.title, required this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      title: 'About Draw Near',
      image: 'assets/images/draw_near.jpeg',
      description: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
          "industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it "
  ),
  OnboardingContent(
      title: 'About Bible',
      image: 'assets/images/bible.jpeg',
      description: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
          "industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it "
  ),
  OnboardingContent(
      title: 'About Prayer',
      image: 'assets/images/prayer.jpeg',
      description: "simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the "
          "industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it "
  ),
];