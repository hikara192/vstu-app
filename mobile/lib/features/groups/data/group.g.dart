// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  facultyName: json['faculty_name'] as String?,
  facultyType: json['faculty_type'] as String?,
  course: (json['course'] as num?)?.toInt(),
  educationLevel: json['education_level'] as String?,
  specShort: json['spec_short'] as String?,
  specName: json['spec_name'] as String?,
  specCode: json['spec_code'] as String?,
);

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'faculty_name': ?instance.facultyName,
  'faculty_type': ?instance.facultyType,
  'course': ?instance.course,
  'education_level': ?instance.educationLevel,
  'spec_short': ?instance.specShort,
  'spec_name': ?instance.specName,
  'spec_code': ?instance.specCode,
};
