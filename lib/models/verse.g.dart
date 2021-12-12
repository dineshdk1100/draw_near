// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verse _$VerseFromJson(Map<String, dynamic> json) => Verse(
      json['Record Id'] as String,
      json['Verse line'] as String,
      json['Full verse'] ?? "" as String,
      (json['Devotions'] as List<dynamic>).map((e) => e as String).toList(),
      json['Last Modified Time'] as int,
    );

Map<String, dynamic> _$VerseToJson(Verse instance) => <String, dynamic>{
      'Record Id': instance.recordId,
      'Verse line': instance.verseLine,
      'Full verse': instance.fullVerse,
      'Devotions': instance.devotions,
      'Last Modified Time': instance.lastModifiedTime,
    };
