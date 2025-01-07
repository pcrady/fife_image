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
      pixelSize: (json['pixel_size'] as num?)?.toDouble() ?? defaultPixelSize,
      cellSize: (json['cell_size'] as num?)?.toDouble() ?? defaultCellSize,
      units: json['units'] as String? ?? lengthScale,
      channelNumber:
          (json['channel_number'] as num?)?.toInt() ?? totalChannelNumber,
      colocalizationConfig: (json['colocalization_config'] as List<dynamic>?)
              ?.map((e) => Map<String, bool>.from(e as Map))
              .toList() ??
          const [],
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
      'pixel_size': instance.pixelSize,
      'cell_size': instance.cellSize,
      'units': instance.units,
      'channel_number': instance.channelNumber,
      'colocalization_config': instance.colocalizationConfig,
    };

const _$LeftMenuEnumEnumMap = {
  LeftMenuEnum.functionSettings: 'functionSettings',
  LeftMenuEnum.functionImageSelection: 'functionImageSelection',
};
