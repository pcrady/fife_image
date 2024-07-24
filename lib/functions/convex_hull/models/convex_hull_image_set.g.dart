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
    _$ConvexHullImageSetImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('base_name', instance.baseName);
  writeNotNull('images', instance.images?.map((e) => e.toJson()).toList());
  val['results'] = instance.results.toJson();
  return val;
}
