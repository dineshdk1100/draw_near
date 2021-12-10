// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['Record Id'] as String,
      json['Name'] as String,
      json['Description'] as String,
      (json['Photo'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      json['Last Modified Time'] as int,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'Record Id': instance.recordId,
      'Name': instance.name,
      'Description': instance.description,
      'Photo': instance.photo,
      'Last Modified Time': instance.lastModifiedTime,
    };
