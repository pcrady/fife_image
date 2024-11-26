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
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ConvexHullResultsImplToJson(
        _$ConvexHullResultsImpl instance) =>
    <String, dynamic>{
      if (instance.inflammation?.toJson() case final value?)
        'inflammation': value,
      if (instance.simplex?.toJson() case final value?) 'simplex': value,
      if (instance.data case final value?) 'data': value,
    };
