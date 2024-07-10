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
      totalCd4Area: (json['total_cd4_area'] as num?)?.toDouble(),
      totalCd8Area: (json['total_cd8_area'] as num?)?.toDouble(),
      totalInsulinArea: (json['total_insulin_area'] as num?)?.toDouble(),
      totalGlucagonArea: (json['total_glucagon_area'] as num?)?.toDouble(),
      totalPdl1Area: (json['total_pdl1_area'] as num?)?.toDouble(),
      isletCd4Area: (json['islet_cd4_area'] as num?)?.toDouble(),
      isletCd8Area: (json['islet_cd8_area'] as num?)?.toDouble(),
      isletInsulinArea: (json['islet_insulin_area'] as num?)?.toDouble(),
      isletGlucagonArea: (json['islet_glucagon_area'] as num?)?.toDouble(),
      isletPdl1Area: (json['islet_pdl1_area'] as num?)?.toDouble(),
      cd4PercentIsletArea: (json['cd4_percent_islet_area'] as num?)?.toDouble(),
      cd8PercentIsletArea: (json['cd8_percent_islet_area'] as num?)?.toDouble(),
      insulinPercentIsletArea:
          (json['insulin_percent_islet_area'] as num?)?.toDouble(),
      glucagonPercentIsletArea:
          (json['glucagon_percent_islet_area'] as num?)?.toDouble(),
      pdl1PercentIsletArea:
          (json['pdl1_percent_islet_area'] as num?)?.toDouble(),
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
  writeNotNull('total_cd4_area', instance.totalCd4Area);
  writeNotNull('total_cd8_area', instance.totalCd8Area);
  writeNotNull('total_insulin_area', instance.totalInsulinArea);
  writeNotNull('total_glucagon_area', instance.totalGlucagonArea);
  writeNotNull('total_pdl1_area', instance.totalPdl1Area);
  writeNotNull('islet_cd4_area', instance.isletCd4Area);
  writeNotNull('islet_cd8_area', instance.isletCd8Area);
  writeNotNull('islet_insulin_area', instance.isletInsulinArea);
  writeNotNull('islet_glucagon_area', instance.isletGlucagonArea);
  writeNotNull('islet_pdl1_area', instance.isletPdl1Area);
  writeNotNull('cd4_percent_islet_area', instance.cd4PercentIsletArea);
  writeNotNull('cd8_percent_islet_area', instance.cd8PercentIsletArea);
  writeNotNull('insulin_percent_islet_area', instance.insulinPercentIsletArea);
  writeNotNull(
      'glucagon_percent_islet_area', instance.glucagonPercentIsletArea);
  writeNotNull('pdl1_percent_islet_area', instance.pdl1PercentIsletArea);
  return val;
}
