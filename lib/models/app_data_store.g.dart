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
      loading: json['loading'] as bool? ?? false,
      function: $enumDecodeNullable(_$FunctionsEnumEnumMap, json['function']) ??
          FunctionsEnum.functions,
      workingDirectory: json['working_directory'] as String?,
    );

Map<String, dynamic> _$$AppDataStoreImplToJson(_$AppDataStoreImpl instance) =>
    <String, dynamic>{
      if (instance.selectedImage?.toJson() case final value?)
        'selected_image': value,
      'loading': instance.loading,
      'function': _$FunctionsEnumEnumMap[instance.function]!,
      if (instance.workingDirectory case final value?)
        'working_directory': value,
    };

const _$FunctionsEnumEnumMap = {
  FunctionsEnum.functions: 'functions',
  FunctionsEnum.convexHull: 'convexHull',
};
