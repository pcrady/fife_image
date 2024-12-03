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
  ConvexHullResults? get activeResults => throw _privateConstructorUsedError;
  AbstractImage? get selectedImage => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  FunctionsEnum get function => throw _privateConstructorUsedError;

  /// Serializes this AppDataStore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {ConvexHullResults? activeResults,
      AbstractImage? selectedImage,
      bool loading,
      FunctionsEnum function});

  $ConvexHullResultsCopyWith<$Res>? get activeResults;
  $AbstractImageCopyWith<$Res>? get selectedImage;
}

/// @nodoc
class _$AppDataStoreCopyWithImpl<$Res, $Val extends AppDataStore>
    implements $AppDataStoreCopyWith<$Res> {
  _$AppDataStoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeResults = freezed,
    Object? selectedImage = freezed,
    Object? loading = null,
    Object? function = null,
  }) {
    return _then(_value.copyWith(
      activeResults: freezed == activeResults
          ? _value.activeResults
          : activeResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults?,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as FunctionsEnum,
    ) as $Val);
  }

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConvexHullResultsCopyWith<$Res>? get activeResults {
    if (_value.activeResults == null) {
      return null;
    }

    return $ConvexHullResultsCopyWith<$Res>(_value.activeResults!, (value) {
      return _then(_value.copyWith(activeResults: value) as $Val);
    });
  }

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
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
      {ConvexHullResults? activeResults,
      AbstractImage? selectedImage,
      bool loading,
      FunctionsEnum function});

  @override
  $ConvexHullResultsCopyWith<$Res>? get activeResults;
  @override
  $AbstractImageCopyWith<$Res>? get selectedImage;
}

/// @nodoc
class __$$AppDataStoreImplCopyWithImpl<$Res>
    extends _$AppDataStoreCopyWithImpl<$Res, _$AppDataStoreImpl>
    implements _$$AppDataStoreImplCopyWith<$Res> {
  __$$AppDataStoreImplCopyWithImpl(
      _$AppDataStoreImpl _value, $Res Function(_$AppDataStoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeResults = freezed,
    Object? selectedImage = freezed,
    Object? loading = null,
    Object? function = null,
  }) {
    return _then(_$AppDataStoreImpl(
      activeResults: freezed == activeResults
          ? _value.activeResults
          : activeResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults?,
      selectedImage: freezed == selectedImage
          ? _value.selectedImage
          : selectedImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      function: null == function
          ? _value.function
          : function // ignore: cast_nullable_to_non_nullable
              as FunctionsEnum,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$AppDataStoreImpl implements _AppDataStore {
  const _$AppDataStoreImpl(
      {this.activeResults,
      this.selectedImage,
      this.loading = false,
      this.function = FunctionsEnum.functions});

  factory _$AppDataStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDataStoreImplFromJson(json);

  @override
  final ConvexHullResults? activeResults;
  @override
  final AbstractImage? selectedImage;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final FunctionsEnum function;

  @override
  String toString() {
    return 'AppDataStore(activeResults: $activeResults, selectedImage: $selectedImage, loading: $loading, function: $function)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataStoreImpl &&
            (identical(other.activeResults, activeResults) ||
                other.activeResults == activeResults) &&
            (identical(other.selectedImage, selectedImage) ||
                other.selectedImage == selectedImage) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.function, function) ||
                other.function == function));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, activeResults, selectedImage, loading, function);

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
      {final ConvexHullResults? activeResults,
      final AbstractImage? selectedImage,
      final bool loading,
      final FunctionsEnum function}) = _$AppDataStoreImpl;

  factory _AppDataStore.fromJson(Map<String, dynamic> json) =
      _$AppDataStoreImpl.fromJson;

  @override
  ConvexHullResults? get activeResults;
  @override
  AbstractImage? get selectedImage;
  @override
  bool get loading;
  @override
  FunctionsEnum get function;

  /// Create a copy of AppDataStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDataStoreImplCopyWith<_$AppDataStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
