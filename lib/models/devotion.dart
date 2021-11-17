import 'package:json_annotation/json_annotation.dart';

part 'devotion.g.dart';

@JsonSerializable(explicitToJson: true)
class Devotion {
  DateTime timestamp;
  String title;
  String song;
  String biblePortion;
  String verse;
  String fullVerse;
  String body;
  String reflectRespond;
  String prayer;
  Quote quote;
  String author;
  DateTime lastModified;

  Devotion(
      this.timestamp,
      this.title,
      this.song,
      this.biblePortion,
      this.verse,
      this.fullVerse,
      this.body,
      this.reflectRespond,
      this.prayer,
      this.quote,
      this.author,
      this.lastModified);

  factory Devotion.fromJson(Map<String, dynamic> json) =>
      _$DevotionFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionToJson(this);
}

@JsonSerializable()
class Quote {
  String body;
  String author;

  Quote(this.body, this.author);

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}
