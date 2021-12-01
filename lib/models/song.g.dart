// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      json['Record Id'] as String,
      json['Body'] as String,
      (json['Devotions'] as List<dynamic>).map((e) => e as String).toList(),
      json['Number'] as String,
      json['Last Modified Time'] as int,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'Record Id': instance.recordId,
      'Body': instance.body,
      'Devotions': instance.devotions,
      'Number': instance.number,
      'Last Modified Time': instance.lastModifiedTime,
    };
