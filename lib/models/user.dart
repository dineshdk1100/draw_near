import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserDetails {
  String uid;
  String displayName;
  String? email;
  String? photoURL;
  String? phoneNumber;

  //constructor
  UserDetails(this.uid, this.displayName, {this.email, this.photoURL, this.phoneNumber});

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}


