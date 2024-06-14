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
  List<AbstractImage>? get images => throw _privateConstructorUsedError;
  int? get selectedImageIndex => throw _privateConstructorUsedError;

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
  $Res call({List<AbstractImage>? images, int? selectedImageIndex});
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
    Object? images = freezed,
    Object? selectedImageIndex = freezed,
  }) {
    return _then(_value.copyWith(
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AbstractImage>?,
      selectedImageIndex: freezed == selectedImageIndex
          ? _value.selectedImageIndex
          : selectedImageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
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
  $Res call({List<AbstractImage>? images, int? selectedImageIndex});
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
    Object? images = freezed,
    Object? selectedImageIndex = freezed,
  }) {
    return _then(_$AppDataStoreImpl(
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AbstractImage>?,
      selectedImageIndex: freezed == selectedImageIndex
          ? _value.selectedImageIndex
          : selectedImageIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppDataStoreImpl implements _AppDataStore {
  const _$AppDataStoreImpl(
      {final List<AbstractImage>? images, this.selectedImageIndex})
      : _images = images;

  factory _$AppDataStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDataStoreImplFromJson(json);

  final List<AbstractImage>? _images;
  @override
  List<AbstractImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? selectedImageIndex;

  @override
  String toString() {
    return 'AppDataStore(images: $images, selectedImageIndex: $selectedImageIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDataStoreImpl &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.selectedImageIndex, selectedImageIndex) ||
                other.selectedImageIndex == selectedImageIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_images), selectedImageIndex);

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
      {final List<AbstractImage>? images,
      final int? selectedImageIndex}) = _$AppDataStoreImpl;

  factory _AppDataStore.fromJson(Map<String, dynamic> json) =
      _$AppDataStoreImpl.fromJson;

  @override
  List<AbstractImage>? get images;
  @override
  int? get selectedImageIndex;
  @override
  @JsonKey(ignore: true)
  _$$AppDataStoreImplCopyWith<_$AppDataStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
