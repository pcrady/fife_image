// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AbstractImageImpl _$$AbstractImageImplFromJson(Map<String, dynamic> json) =>
    _$AbstractImageImpl(
      fileImage:
          const FileImageConverter().fromJson(json['file_image'] as String),
      md5Hash: json['md5_hash'] as String?,
      relativeSelectionCoordinates: const OffsetListConverter().fromJson(
          json['relative_selection_coordinates'] as List<List<double>>?),
    );

Map<String, dynamic> _$$AbstractImageImplToJson(_$AbstractImageImpl instance) =>
    <String, dynamic>{
      'file_image': const FileImageConverter().toJson(instance.fileImage),
      if (instance.md5Hash case final value?) 'md5_hash': value,
      if (const OffsetListConverter()
              .toJson(instance.relativeSelectionCoordinates)
          case final value?)
        'relative_selection_coordinates': value,
    };
