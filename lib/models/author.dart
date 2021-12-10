import 'package:json_annotation/json_annotation.dart';
part 'author.g.dart';

@JsonSerializable()
class Author {
  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Description')
  String description;
  @JsonKey(name: 'Photo')
  List<Map<String, dynamic>> photo;
  @JsonKey(name: 'Last Modified Time')
  int lastModifiedTime;

  

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  Author(this.recordId, this.name, this.description, this.photo,
      this.lastModifiedTime);
}
