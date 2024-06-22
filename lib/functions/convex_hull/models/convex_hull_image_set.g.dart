// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_image_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullImageSetImpl _$$ConvexHullImageSetImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullImageSetImpl(
      baseName: json['base_name'] as String?,
      channel0: json['channel0'] == null
          ? null
          : AbstractImage.fromJson(json['channel0'] as Map<String, dynamic>),
      channel0BackgroundCorrect: json['channel0_background_correct'] == null
          ? null
          : AbstractImage.fromJson(
              json['channel0_background_correct'] as Map<String, dynamic>),
      channel1: json['channel1'] == null
          ? null
          : AbstractImage.fromJson(json['channel1'] as Map<String, dynamic>),
      channel1BackgroundCorrect: json['channel1_background_correct'] == null
          ? null
          : AbstractImage.fromJson(
              json['channel1_background_correct'] as Map<String, dynamic>),
      channel2: json['channel2'] == null
          ? null
          : AbstractImage.fromJson(json['channel2'] as Map<String, dynamic>),
      channel2BackgroundCorrect: json['channel2_background_correct'] == null
          ? null
          : AbstractImage.fromJson(
              json['channel2_background_correct'] as Map<String, dynamic>),
      channel3: json['channel3'] == null
          ? null
          : AbstractImage.fromJson(json['channel3'] as Map<String, dynamic>),
      channel3BackgroundCorrect: json['channel3_background_correct'] == null
          ? null
          : AbstractImage.fromJson(
              json['channel3_background_correct'] as Map<String, dynamic>),
      channel4: json['channel4'] == null
          ? null
          : AbstractImage.fromJson(json['channel4'] as Map<String, dynamic>),
      channel4BackgroundCorrect: json['channel4_background_correct'] == null
          ? null
          : AbstractImage.fromJson(
              json['channel4_background_correct'] as Map<String, dynamic>),
      overlay: json['overlay'] == null
          ? null
          : AbstractImage.fromJson(json['overlay'] as Map<String, dynamic>),
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
  writeNotNull('channel0', instance.channel0?.toJson());
  writeNotNull('channel0_background_correct',
      instance.channel0BackgroundCorrect?.toJson());
  writeNotNull('channel1', instance.channel1?.toJson());
  writeNotNull('channel1_background_correct',
      instance.channel1BackgroundCorrect?.toJson());
  writeNotNull('channel2', instance.channel2?.toJson());
  writeNotNull('channel2_background_correct',
      instance.channel2BackgroundCorrect?.toJson());
  writeNotNull('channel3', instance.channel3?.toJson());
  writeNotNull('channel3_background_correct',
      instance.channel3BackgroundCorrect?.toJson());
  writeNotNull('channel4', instance.channel4?.toJson());
  writeNotNull('channel4_background_correct',
      instance.channel4BackgroundCorrect?.toJson());
  writeNotNull('overlay', instance.overlay?.toJson());
  val['results'] = instance.results.toJson();
  return val;
}
