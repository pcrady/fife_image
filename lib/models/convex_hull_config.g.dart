// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullConfigImpl _$$ConvexHullConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullConfigImpl(
      activeImageSetBaseName: json['active_image_set_base_name'] as String?,
      channel0SearchPattern:
          json['channel0_search_pattern'] as String? ?? 'ch00',
      channel1SearchPattern:
          json['channel1_search_pattern'] as String? ?? 'ch01',
      channel2SearchPattern:
          json['channel2_search_pattern'] as String? ?? 'ch02',
      channel3SearchPattern:
          json['channel3_search_pattern'] as String? ?? 'ch03',
      channel4SearchPattern:
          json['channel4_search_pattern'] as String? ?? 'ch04',
      overlaySearchPattern:
          json['overlay_search_pattern'] as String? ?? 'overlay',
      channel0ProteinName: json['channel0_protein_name'] as String? ?? 'CD4',
      channel1ProteinName:
          json['channel1_protein_name'] as String? ?? 'Glucagon',
      channel2ProteinName:
          json['channel2_protein_name'] as String? ?? 'Insulin',
      channel3ProteinName: json['channel3_protein_name'] as String? ?? 'CD8',
      channel4ProteinName: json['channel4_protein_name'] as String? ?? '???',
    );

Map<String, dynamic> _$$ConvexHullConfigImplToJson(
    _$ConvexHullConfigImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('active_image_set_base_name', instance.activeImageSetBaseName);
  val['channel0_search_pattern'] = instance.channel0SearchPattern;
  val['channel1_search_pattern'] = instance.channel1SearchPattern;
  val['channel2_search_pattern'] = instance.channel2SearchPattern;
  val['channel3_search_pattern'] = instance.channel3SearchPattern;
  val['channel4_search_pattern'] = instance.channel4SearchPattern;
  val['overlay_search_pattern'] = instance.overlaySearchPattern;
  val['channel0_protein_name'] = instance.channel0ProteinName;
  val['channel1_protein_name'] = instance.channel1ProteinName;
  val['channel2_protein_name'] = instance.channel2ProteinName;
  val['channel3_protein_name'] = instance.channel3ProteinName;
  val['channel4_protein_name'] = instance.channel4ProteinName;
  return val;
}
