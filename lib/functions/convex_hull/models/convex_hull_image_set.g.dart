// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_image_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullImageSetImpl _$$ConvexHullImageSetImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullImageSetImpl(
      baseName: json['base_name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => AbstractImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      results: json['results'] == null
          ? const ConvexHullResults()
          : ConvexHullResults.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ConvexHullImageSetImplToJson(
        _$ConvexHullImageSetImpl instance) =>
    <String, dynamic>{
      if (instance.baseName case final value?) 'base_name': value,
      if (instance.images?.map((e) => e.toJson()).toList() case final value?)
        'images': value,
      'results': instance.results.toJson(),
    };
