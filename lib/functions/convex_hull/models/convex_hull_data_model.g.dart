// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullDataModelImpl _$$ConvexHullDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullDataModelImpl(
      totalImageArea: (json['total_image_area'] as num?)?.toDouble(),
      totalIsletArea: (json['total_islet_area'] as num?)?.toDouble(),
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$$ConvexHullDataModelImplToJson(
    _$ConvexHullDataModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('total_image_area', instance.totalImageArea);
  writeNotNull('total_islet_area', instance.totalIsletArea);
  writeNotNull('data', instance.data);
  return val;
}
