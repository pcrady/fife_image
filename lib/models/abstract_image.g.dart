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

Map<String, dynamic> _$$AbstractImageImplToJson(_$AbstractImageImpl instance) {
  final val = <String, dynamic>{
    'image_path': instance.imagePath,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('md5_hash', instance.md5Hash);
  writeNotNull('file', const Uint8ListConverter().toJson(instance.file));
  writeNotNull(
      'relative_selection_coordinates',
      const OffsetListConverter()
          .toJson(instance.relativeSelectionCoordinates));
  return val;
}
