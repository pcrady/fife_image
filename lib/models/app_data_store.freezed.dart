// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_data_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppDataStore _$AppDataStoreFromJson(Map<String, dynamic> json) {
  return _AppDataStore.fromJson(json);
}

/// @nodoc
mixin _$AppDataStore {
  AbstractImage? get selectedImage => throw _privateConstructorUsedError;
  FunctionsEnum get function => throw _privateConstructorUsedError;
  LeftMenuEnum get leftMenu => throw _privateConstructorUsedError;
  ConvexHullConfig get convexHullConfig => throw _privateConstructorUsedError;
  ConvexHullResults get convexHullResults => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppDataStoreCopyWith<AppDataStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDataStoreCopyWith<$Res> {
  factory $AppDataStoreCopyWith(
          AppDataStore value, $Res Function(AppDataStore) then) =
      _$AppDataStoreCopyWithImpl<$Res, AppDataStore>;
  @useResult
  $Res call(
      {AbstractImage? selectedImage,
      FunctionsEnum function,
      LeftMenuEnum leftMenu,
      ConvexHullConfig convexHullConfig,
      ConvexHullResults convexHullResults});

  $AbstractImageCopyWith<$Res>? get selectedImage;
  $ConvexHullConfigCopyWith<$Res> get convexHullConfig;
  $ConvexHullResultsCopyWith<$Res> get convexHullResults;
}

/// @nodoc
class _$AppDataStoreCopyWithImpl<$Res, $Val extends AppDataStore>
    implements $AppDataStoreCopyWith<$Res> {
  _$AppDataStoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedImage = freezed,
    Object? function = null,
    Object? leftMenu = null,
    Object? convexHullConfig = null,
    Object? convexHullResults = null,
  }) {
    return _then(_value.copyWith(
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as FunctionsEnum,
      leftMenu: null == leftMenu
          ? _value.leftMenu
          : leftMenu // ignore: cast_nullable_to_non_nullable
              as LeftMenuEnum,
      convexHullConfig: null == convexHullConfig
          ? _value.convexHullConfig
          : convexHullConfig // ignore: cast_nullable_to_non_nullable
              as ConvexHullConfig,
      convexHullResults: null == convexHullResults
          ? _value.convexHullResults
          : convexHullResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AbstractImageCopyWith<$Res>? get selectedImage {
    if (_value.selectedImage == null) {
      return null;
    }

    return $AbstractImageCopyWith<$Res>(_value.selectedImage!, (value) {
      return _then(_value.copyWith(selectedImage: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConvexHullConfigCopyWith<$Res> get convexHullConfig {
    return $ConvexHullConfigCopyWith<$Res>(_value.convexHullConfig, (value) {
      return _then(_value.copyWith(convexHullConfig: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConvexHullResultsCopyWith<$Res> get convexHullResults {
    return $ConvexHullResultsCopyWith<$Res>(_value.convexHullResults, (value) {
      return _then(_value.copyWith(convexHullResults: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppDataStoreImplCopyWith<$Res>
    implements $AppDataStoreCopyWith<$Res> {
  factory _$$AppDataStoreImplCopyWith(
          _$AppDataStoreImpl value, $Res Function(_$AppDataStoreImpl) then) =
      __$$AppDataStoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AbstractImage? selectedImage,
      FunctionsEnum function,
      LeftMenuEnum leftMenu,
      ConvexHullConfig convexHullConfig,
      ConvexHullResults convexHullResults});

  @override
  $AbstractImageCopyWith<$Res>? get selectedImage;
  @override
  $ConvexHullConfigCopyWith<$Res> get convexHullConfig;
  @override
  $ConvexHullResultsCopyWith<$Res> get convexHullResults;
}

/// @nodoc
class __$$AppDataStoreImplCopyWithImpl<$Res>
    extends _$AppDataStoreCopyWithImpl<$Res, _$AppDataStoreImpl>
    implements _$$AppDataStoreImplCopyWith<$Res> {
  __$$AppDataStoreImplCopyWithImpl(
      _$AppDataStoreImpl _value, $Res Function(_$AppDataStoreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedImage = freezed,
    Object? function = null,
    Object? leftMenu = null,
    Object? convexHullConfig = null,
    Object? convexHullResults = null,
  }) {
    return _then(_$AppDataStoreImpl(
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as FunctionsEnum,
      leftMenu: null == leftMenu
          ? _value.leftMenu
          : leftMenu // ignore: cast_nullable_to_non_nullable
              as LeftMenuEnum,
      convexHullConfig: null == convexHullConfig
          ? _value.convexHullConfig
          : convexHullConfig // ignore: cast_nullable_to_non_nullable
              as ConvexHullConfig,
      convexHullResults: null == convexHullResults
          ? _value.convexHullResults
          : convexHullResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$AppDataStoreImpl implements _AppDataStore {
  const _$AppDataStoreImpl(
      {this.selectedImage,
      this.function = FunctionsEnum.functions,
      this.leftMenu = LeftMenuEnum.images,
      this.convexHullConfig = const ConvexHullConfig(),
      this.convexHullResults = const ConvexHullResults()});

  factory _$AppDataStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDataStoreImplFromJson(json);

  @override
  final AbstractImage? selectedImage;
  @override
  @JsonKey()
  final FunctionsEnum function;
  @override
  @JsonKey()
  final LeftMenuEnum leftMenu;
  @override
  @JsonKey()
  final ConvexHullConfig convexHullConfig;
  @override
  @JsonKey()
  final ConvexHullResults convexHullResults;

  @override
  String toString() {
    return 'AppDataStore(selectedImage: $selectedImage, function: $function, leftMenu: $leftMenu, convexHullConfig: $convexHullConfig, convexHullResults: $convexHullResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataStoreImpl &&
            (identical(other.selectedImage, selectedImage) ||
                other.selectedImage == selectedImage) &&
            (identical(other.function, function) ||
                other.function == function) &&
            (identical(other.leftMenu, leftMenu) ||
                other.leftMenu == leftMenu) &&
            (identical(other.convexHullConfig, convexHullConfig) ||
                other.convexHullConfig == convexHullConfig) &&
            (identical(other.convexHullResults, convexHullResults) ||
                other.convexHullResults == convexHullResults));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, selectedImage, function,
      leftMenu, convexHullConfig, convexHullResults);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDataStoreImplCopyWith<_$AppDataStoreImpl> get copyWith =>
      __$$AppDataStoreImplCopyWithImpl<_$AppDataStoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppDataStoreImplToJson(
      this,
    );
  }
}

abstract class _AppDataStore implements AppDataStore {
  const factory _AppDataStore(
      {final AbstractImage? selectedImage,
      final FunctionsEnum function,
      final LeftMenuEnum leftMenu,
      final ConvexHullConfig convexHullConfig,
      final ConvexHullResults convexHullResults}) = _$AppDataStoreImpl;

  factory _AppDataStore.fromJson(Map<String, dynamic> json) =
      _$AppDataStoreImpl.fromJson;

  @override
  AbstractImage? get selectedImage;
  @override
  FunctionsEnum get function;
  @override
  LeftMenuEnum get leftMenu;
  @override
  ConvexHullConfig get convexHullConfig;
  @override
  ConvexHullResults get convexHullResults;
  @override
  @JsonKey(ignore: true)
  _$$AppDataStoreImplCopyWith<_$AppDataStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
