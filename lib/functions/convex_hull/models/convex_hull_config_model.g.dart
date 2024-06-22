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
      channel0ProteinName: json['channel0_protein_name'] as String? ?? cd4,
      channel1ProteinName: json['channel1_protein_name'] as String? ?? glucagon,
      channel2ProteinName: json['channel2_protein_name'] as String? ?? insulin,
      channel3ProteinName: json['channel3_protein_name'] as String? ?? cd8,
      channel4ProteinName: json['channel4_protein_name'] as String? ?? pdl1,
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
