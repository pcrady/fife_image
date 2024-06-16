// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDataStoreImpl _$$AppDataStoreImplFromJson(Map<String, dynamic> json) =>
    _$AppDataStoreImpl(
      selectedImage: json['selected_image'] == null
          ? null
          : AbstractImage.fromJson(
              json['selected_image'] as Map<String, dynamic>),
      function: $enumDecodeNullable(_$FunctionsEnumEnumMap, json['function']) ??
          FunctionsEnum.functions,
      leftMenu: $enumDecodeNullable(_$LeftMenuEnumEnumMap, json['left_menu']) ??
          LeftMenuEnum.images,
      convexHullState: json['convex_hull_state'] == null
          ? const ConvexHullState()
          : ConvexHullState.fromJson(
              json['convex_hull_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppDataStoreImplToJson(_$AppDataStoreImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('selected_image', instance.selectedImage?.toJson());
  val['function'] = _$FunctionsEnumEnumMap[instance.function]!;
  val['left_menu'] = _$LeftMenuEnumEnumMap[instance.leftMenu]!;
  val['convex_hull_state'] = instance.convexHullState.toJson();
  return val;
}

const _$FunctionsEnumEnumMap = {
  FunctionsEnum.functions: 'functions',
  FunctionsEnum.convexHull: 'convexHull',
};

const _$LeftMenuEnumEnumMap = {
  LeftMenuEnum.images: 'images',
  LeftMenuEnum.functionSettings: 'functionSettings',
  LeftMenuEnum.functionResults: 'functionResults',
};
