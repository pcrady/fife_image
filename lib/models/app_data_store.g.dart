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
  return val;
}

const _$FunctionsEnumEnumMap = {
  FunctionsEnum.functions: 'functions',
  FunctionsEnum.convexHull: 'convexHull',
};
