import 'package:json_annotation/json_annotation.dart';

part 'carousel_image.g.dart';

@JsonSerializable()
class CarouselImage {
  @JsonKey(name: 'Record Id')
  String recordId;
  @JsonKey(name: 'images')
  List images;

  factory CarouselImage.fromJson(Map<String, dynamic> json) =>
      _$CarouselImageFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselImageToJson(this);

  CarouselImage(this.recordId, this.images);
}
