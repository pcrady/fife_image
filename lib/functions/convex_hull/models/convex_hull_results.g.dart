// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullResultsImpl _$$ConvexHullResultsImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullResultsImpl(
      inflammation: json['inflammation'] == null
          ? null
          : AbstractImage.fromJson(
              json['inflammation'] as Map<String, dynamic>),
      simplex: json['simplex'] == null
          ? null
          : AbstractImage.fromJson(json['simplex'] as Map<String, dynamic>),
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$ConvexHullResultsImplToJson(
    _$ConvexHullResultsImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('inflammation', instance.inflammation?.toJson());
  writeNotNull('simplex', instance.simplex?.toJson());
  writeNotNull('data', instance.data);
  return val;
}
