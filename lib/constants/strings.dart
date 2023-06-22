
class StringsProvider {

  static var emptylines = "\n\n";

  static var emptyline = "\n";

  static var dots = "...";

  static var downloadLink = "Download the app for more devotions";

  static var iosLink = "Ios link: https://apps.apple.com/in/app/draw-near-family-devotion/id1602072236";

  static var androidLink = "Android link: https://play.google.com/store/apps/details?id=com.techcatalyst.draw_near";

  static var _stringMap = {
    "devotionOfDay" : {
      "ta_IN": ">>இன்றைய பிரார்தனை<<",
      "en_IN": ">>Devotion of the day<<" 
    }
  };


  static getLocalisedString(var stringName, var locale) {
    return _stringMap[stringName]![locale];
  }
}