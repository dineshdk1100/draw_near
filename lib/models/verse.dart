import 'package:json_annotation/json_annotation.dart';
part 'verse.g.dart';


@JsonSerializable()
class Verse {
  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'Verse line')
  String verseLine;
  @JsonKey(name: 'Full verse')
  String fullVerse;
  @JsonKey(name: 'Devotions')
  List<String> devotions;
  @JsonKey(name: 'Last Modified Time')
  int lastModifiedTime;

  Verse(
      this.recordId,
      this.verseLine,
      this.fullVerse,
      this.devotions,
      this.lastModifiedTime
      );

  factory Verse.fromJson(Map<String, dynamic> json) =>
      _$VerseFromJson(json);

  Map<String, dynamic> toJson() => _$VerseToJson(this);

}