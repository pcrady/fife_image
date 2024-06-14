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
      selectedImageIndex: (json['selectedImageIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AppDataStoreImplToJson(_$AppDataStoreImpl instance) =>
    <String, dynamic>{
      'images': instance.images,
      'selectedImageIndex': instance.selectedImageIndex,
    };
