// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Devotion _$DevotionFromJson(Map<String, dynamic> json) => Devotion(
      DateTime.parse(json['timestamp'] as String),
      json['title'] as String,
      json['song'] as String,
      json['fullSong'] as String,
      json['biblePortion'] as String,
      json['verse'] as String,
      json['fullVerse'] as String,
      json['body'] as String,
      json['reflectRespond'] as String,
      json['prayer'] as String,
      Quote.fromJson(json['quote'] as Map<String, dynamic>),
      json['author'] as String,
      DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$DevotionToJson(Devotion instance) => <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'title': instance.title,
      'song': instance.song,
      'fullSong': instance.fullSong,
      'biblePortion': instance.biblePortion,
      'verse': instance.verse,
      'fullVerse': instance.fullVerse,
      'body': instance.body,
      'reflectRespond': instance.reflectRespond,
      'prayer': instance.prayer,
      'quote': instance.quote.toJson(),
      'author': instance.author,
      'lastModified': instance.lastModified.toIso8601String(),
    };

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
      json['body'] as String,
      json['author'] as String,
    );

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      'body': instance.body,
      'author': instance.author,
    };
