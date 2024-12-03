// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullConfigModelImpl _$$ConvexHullConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullConfigModelImpl(
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
      searchPatternOverlayColorConfig:
          (json['search_pattern_overlay_color_config'] as Map<String, dynamic>?)
                  ?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      imageWidth: (json['image_width'] as num?)?.toDouble() ?? width,
      imageHeight: (json['image_height'] as num?)?.toDouble() ?? length,
      units: json['units'] as String? ?? lengthScale,
      channelNumber:
          (json['channel_number'] as num?)?.toInt() ?? totalChannelNumber,
    );

Map<String, dynamic> _$$ConvexHullConfigModelImplToJson(
        _$ConvexHullConfigModelImpl instance) =>
    <String, dynamic>{
      'left_menu_enum': _$LeftMenuEnumEnumMap[instance.leftMenuEnum]!,
      'overlay_search_pattern': instance.overlaySearchPattern,
      'search_pattern_protein_config': instance.searchPatternProteinConfig,
      'search_pattern_overlay_config': instance.searchPatternOverlayConfig,
      'search_pattern_overlay_color_config':
          instance.searchPatternOverlayColorConfig,
      'image_width': instance.imageWidth,
      'image_height': instance.imageHeight,
      'units': instance.units,
      'channel_number': instance.channelNumber,
    };

const _$LeftMenuEnumEnumMap = {
  LeftMenuEnum.functionSettings: 'functionSettings',
  LeftMenuEnum.functionImageSelection: 'functionImageSelection',
};
