// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeMonth _$ThemeMonthFromJson(Map<String, dynamic> json) => ThemeMonth(
      json['Record Id'] as String,
      json['Full Month'] as String,
      json['Title'] as String,
      json['Description'] as String,
      json['Last Modified Time'] as int,
    );

Map<String, dynamic> _$ThemeMonthToJson(ThemeMonth instance) =>
    <String, dynamic>{
      'Record Id': instance.recordId,
      'Full Month': instance.fullMonth,
      'Title': instance.title,
      'Description': instance.description,
      'Last Modified Time': instance.lastModifiedTime,
    };
