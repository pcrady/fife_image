// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDataStoreImpl _$$AppDataStoreImplFromJson(Map<String, dynamic> json) =>
    _$AppDataStoreImpl(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => AbstractImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedImage: json['selected_image'] == null
          ? null
          : AbstractImage.fromJson(
              json['selected_image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppDataStoreImplToJson(_$AppDataStoreImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('images', instance.images?.map((e) => e.toJson()).toList());
  writeNotNull('selected_image', instance.selectedImage?.toJson());
  return val;
}
