// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AbstractImageImpl _$$AbstractImageImplFromJson(Map<String, dynamic> json) =>
    _$AbstractImageImpl(
      imagePath: json['image_path'] as String,
      md5Hash: json['md5_hash'] as String?,
      file: const Uint8ListConverter().fromJson(json['file'] as List<int>?),
      relativeSelectionCoordinates: const OffsetListConverter().fromJson(
          json['relative_selection_coordinates'] as List<List<double>>?),
    );

Map<String, dynamic> _$$AbstractImageImplToJson(_$AbstractImageImpl instance) =>
    <String, dynamic>{
      'image_path': instance.imagePath,
      if (instance.md5Hash case final value?) 'md5_hash': value,
      if (const Uint8ListConverter().toJson(instance.file) case final value?)
        'file': value,
      if (const OffsetListConverter()
              .toJson(instance.relativeSelectionCoordinates)
          case final value?)
        'relative_selection_coordinates': value,
    };
