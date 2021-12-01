import 'package:json_annotation/json_annotation.dart';
part 'song.g.dart';


@JsonSerializable()
class Song {
  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'Body')
  String body;
  @JsonKey(name: 'Devotions')
  List<String> devotions;
  @JsonKey(name: 'Number')
  String number;
  @JsonKey(name: 'Last Modified Time')
  int lastModifiedTime;

  Song(
      this.recordId,
      this.body, 
      this.devotions, 
      this.number, 
      this.lastModifiedTime
      );

  factory Song.fromJson(Map<String, dynamic> json) =>
      _$SongFromJson(json);

  Map<String, dynamic> toJson() => _$SongToJson(this);

}