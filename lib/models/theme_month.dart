import 'package:json_annotation/json_annotation.dart';
part 'theme_month.g.dart';


@JsonSerializable()
class ThemeMonth {
  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'Full Month')
  String fullMonth;
  @JsonKey(name: 'Title')
  String title;
  @JsonKey(name: 'Description')
  String description;
  @JsonKey(name: 'Last Modified Time')
  int lastModifiedTime;


  ThemeMonth(this.recordId, this.fullMonth, this.title, this.description,
      this.lastModifiedTime);

  factory ThemeMonth.fromJson(Map<String, dynamic> json) =>
      _$ThemeMonthFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeMonthToJson(this);

}