// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppInfoStore _$AppInfoStoreFromJson(Map<String, dynamic> json) {
  return _AppInfoStore.fromJson(json);
}

/// @nodoc
mixin _$AppInfoStore {
  String get serverVersion => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  bool get initializing => throw _privateConstructorUsedError;

  /// Serializes this AppInfoStore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppInfoStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppInfoStoreCopyWith<AppInfoStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppInfoStoreCopyWith<$Res> {
  factory $AppInfoStoreCopyWith(
          AppInfoStore value, $Res Function(AppInfoStore) then) =
      _$AppInfoStoreCopyWithImpl<$Res, AppInfoStore>;
  @useResult
  $Res call({String serverVersion, String appVersion, bool initializing});
}

/// @nodoc
class _$AppInfoStoreCopyWithImpl<$Res, $Val extends AppInfoStore>
    implements $AppInfoStoreCopyWith<$Res> {
  _$AppInfoStoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppInfoStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverVersion = null,
    Object? appVersion = null,
    Object? initializing = null,
  }) {
    return _then(_value.copyWith(
      serverVersion: null == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      initializing: null == initializing
          ? _value.initializing
          : initializing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppInfoStoreImplCopyWith<$Res>
    implements $AppInfoStoreCopyWith<$Res> {
  factory _$$AppInfoStoreImplCopyWith(
          _$AppInfoStoreImpl value, $Res Function(_$AppInfoStoreImpl) then) =
      __$$AppInfoStoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String serverVersion, String appVersion, bool initializing});
}

/// @nodoc
class __$$AppInfoStoreImplCopyWithImpl<$Res>
    extends _$AppInfoStoreCopyWithImpl<$Res, _$AppInfoStoreImpl>
    implements _$$AppInfoStoreImplCopyWith<$Res> {
  __$$AppInfoStoreImplCopyWithImpl(
      _$AppInfoStoreImpl _value, $Res Function(_$AppInfoStoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppInfoStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverVersion = null,
    Object? appVersion = null,
    Object? initializing = null,
  }) {
    return _then(_$AppInfoStoreImpl(
      serverVersion: null == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      initializing: null == initializing
          ? _value.initializing
          : initializing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$AppInfoStoreImpl implements _AppInfoStore {
  const _$AppInfoStoreImpl(
      {this.serverVersion = '',
      this.appVersion = '',
      this.initializing = true});

  factory _$AppInfoStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppInfoStoreImplFromJson(json);

  @override
  @JsonKey()
  final String serverVersion;
  @override
  @JsonKey()
  final String appVersion;
  @override
  @JsonKey()
  final bool initializing;

  @override
  String toString() {
    return 'AppInfoStore(serverVersion: $serverVersion, appVersion: $appVersion, initializing: $initializing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppInfoStoreImpl &&
            (identical(other.serverVersion, serverVersion) ||
                other.serverVersion == serverVersion) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.initializing, initializing) ||
                other.initializing == initializing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, serverVersion, appVersion, initializing);

  /// Create a copy of AppInfoStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppInfoStoreImplCopyWith<_$AppInfoStoreImpl> get copyWith =>
      __$$AppInfoStoreImplCopyWithImpl<_$AppInfoStoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppInfoStoreImplToJson(
      this,
    );
  }
}

abstract class _AppInfoStore implements AppInfoStore {
  const factory _AppInfoStore(
      {final String serverVersion,
      final String appVersion,
      final bool initializing}) = _$AppInfoStoreImpl;

  factory _AppInfoStore.fromJson(Map<String, dynamic> json) =
      _$AppInfoStoreImpl.fromJson;

  @override
  String get serverVersion;
  @override
  String get appVersion;
  @override
  bool get initializing;

  /// Create a copy of AppInfoStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppInfoStoreImplCopyWith<_$AppInfoStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
