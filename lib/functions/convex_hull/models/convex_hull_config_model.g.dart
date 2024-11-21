// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullConfigModelImpl _$$ConvexHullConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullConfigModelImpl(
      activeImageSetBaseName: json['active_image_set_base_name'] as String?,
      activeImage: json['active_image'] == null
          ? null
          : AbstractImage.fromJson(
              json['active_image'] as Map<String, dynamic>),
      activeResults: json['active_results'] == null
          ? null
          : ConvexHullResults.fromJson(
              json['active_results'] as Map<String, dynamic>),
      leftMenuEnum:
          $enumDecodeNullable(_$LeftMenuEnumEnumMap, json['left_menu_enum']) ??
              LeftMenuEnum.functionSettings,
      overlaySearchPattern:
          json['overlay_search_pattern'] as String? ?? overlay,
      searchPatternProteinConfig:
          (json['search_pattern_protein_config'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {},
      searchPatternOverlayConfig:
          (json['search_pattern_overlay_config'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
      imageWidth: (json['image_width'] as num?)?.toDouble() ?? width,
      imageHeight: (json['image_height'] as num?)?.toDouble() ?? length,
      units: json['units'] as String? ?? lengthScale,
      channelNumber:
          (json['channel_number'] as num?)?.toInt() ?? totalChannelNumber,
    );

Map<String, dynamic> _$$ConvexHullConfigModelImplToJson(
    _$ConvexHullConfigModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('active_image_set_base_name', instance.activeImageSetBaseName);
  writeNotNull('active_image', instance.activeImage?.toJson());
  writeNotNull('active_results', instance.activeResults?.toJson());
  val['left_menu_enum'] = _$LeftMenuEnumEnumMap[instance.leftMenuEnum]!;
  val['overlay_search_pattern'] = instance.overlaySearchPattern;
  val['search_pattern_protein_config'] = instance.searchPatternProteinConfig;
  val['search_pattern_overlay_config'] = instance.searchPatternOverlayConfig;
  val['image_width'] = instance.imageWidth;
  val['image_height'] = instance.imageHeight;
  val['units'] = instance.units;
  val['channel_number'] = instance.channelNumber;
  return val;
}

const _$LeftMenuEnumEnumMap = {
  LeftMenuEnum.functionSettings: 'functionSettings',
  LeftMenuEnum.functionImageSelection: 'functionImageSelection',
};
