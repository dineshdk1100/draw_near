// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Devotion _$DevotionFromJson(Map<String, dynamic> json) => Devotion(
      json['Record Id'] as String,
      DateTime.parse(json['Date'] as String),
      json['Title'] as String,
      json['Number (from Song)'] as String,
      (json['Song'] as List<dynamic>).map((e) => e as String).toList(),
      json['Bible portion'] as String,
      json['Verse line (from Bible verse)'] as String,
      (json['Bible verse'] as List<dynamic>).map((e) => e as String).toList(),
      json['Body'] as String,
      json['Reflect & Respond'] as String,
      json['Prayer'] as String,
      json['Quote'] as String?,
      json['Quote author'] as String,
      json['Name (from Author)'] as String,
      (json['Author'] as List<dynamic>).map((e) => e as String).toList(),
      json['Last Modified Time'] as int,
    );

Map<String, dynamic> _$DevotionToJson(Devotion instance) => <String, dynamic>{
      'Record Id': instance.recordId,
      'Date': instance.date.toIso8601String(),
      'Title': instance.title,
      'Number (from Song)': instance.songNumber,
      'Song': instance.song,
      'Bible portion': instance.biblePortion,
      'Verse line (from Bible verse)': instance.verseLine,
      'Bible verse': instance.verse,
      'Body': instance.body,
      'Reflect & Respond': instance.reflectRespond,
      'Prayer': instance.prayer,
      'Quote': instance.quote,
      'Quote author': instance.quoteAuthor,
      'Name (from Author)': instance.authorName,
      'Author': instance.author,
      'Last Modified Time': instance.lastModifiedTime,
    };
