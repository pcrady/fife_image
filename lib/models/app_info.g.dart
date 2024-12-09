// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppInfoStoreImpl _$$AppInfoStoreImplFromJson(Map<String, dynamic> json) =>
    _$AppInfoStoreImpl(
      serverVersion: json['server_version'] as String? ?? '',
      appVersion: json['app_version'] as String? ?? '',
    );

Map<String, dynamic> _$$AppInfoStoreImplToJson(_$AppInfoStoreImpl instance) =>
    <String, dynamic>{
      'server_version': instance.serverVersion,
      'app_version': instance.appVersion,
    };
