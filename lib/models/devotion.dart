import 'package:json_annotation/json_annotation.dart';

part 'devotion.g.dart';

@JsonSerializable(explicitToJson: true)
class Devotion {
  static DateTime dateStringToDateTime(String dateString) => DateTime.tryParse(dateString) ?? DateTime.now();
  static String dateTimeToDateString(DateTime dateTime) => "1-1-1";

  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'Date')
  DateTime date;
  @JsonKey(name: 'Title')
  String title;
  @JsonKey(name: 'Number (from Song)')
  List songNumber;
  @JsonKey(name: 'Song')
  List<String> song;
  @JsonKey(name: 'Bible portion')
  String biblePortion;
  @JsonKey(name: 'Verse line (from Bible verse)')
  List verseLine;
  @JsonKey(name: 'Bible verse')
  List<String> verse;
  @JsonKey(name: 'Body')
  String body;
  @JsonKey(name: 'Reflect & Respond')
  String reflectRespond;
  @JsonKey(name: 'Prayer')
  String prayer;
  @JsonKey(name: 'Quote')
  String? quote;
  @JsonKey(name: 'Quote author')
  String quoteAuthor;
  @JsonKey(name: 'Name (from Author)')
  List authorName;
  @JsonKey(name: 'Author')
  List<String> author;
  @JsonKey(name: 'Last Modified Time')
  int lastModifiedTime;

  Devotion(
      this.recordId,
      this.date,
      this.title,
      this.songNumber,
      this.song,
      this.biblePortion,
      this.verseLine,
      this.verse,
      this.body,
      this.reflectRespond,
      this.prayer,
      this.quote,
      this.quoteAuthor,
      this.authorName,
      this.author,
      this.lastModifiedTime);

  factory Devotion.fromJson(Map<String, dynamic> json) =>
      _$DevotionFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionToJson(this);
}

