// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abstract_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AbstractImage _$AbstractImageFromJson(Map<String, dynamic> json) {
  return _AbstractImage.fromJson(json);
}

/// @nodoc
mixin _$AbstractImage {
  @FileImageConverter()
  FileImage get fileImage => throw _privateConstructorUsedError;
  @NullableFileImageConverter()
  FileImage? get thumbnail => throw _privateConstructorUsedError;
  String? get md5Hash => throw _privateConstructorUsedError;
  @OffsetListConverter()
  List<Offset>? get relativeSelectionCoordinates =>
      throw _privateConstructorUsedError;

  /// Serializes this AbstractImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AbstractImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AbstractImageCopyWith<AbstractImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AbstractImageCopyWith<$Res> {
  factory $AbstractImageCopyWith(
          AbstractImage value, $Res Function(AbstractImage) then) =
      _$AbstractImageCopyWithImpl<$Res, AbstractImage>;
  @useResult
  $Res call(
      {@FileImageConverter() FileImage fileImage,
      @NullableFileImageConverter() FileImage? thumbnail,
      String? md5Hash,
      @OffsetListConverter() List<Offset>? relativeSelectionCoordinates});
}

/// @nodoc
class _$AbstractImageCopyWithImpl<$Res, $Val extends AbstractImage>
    implements $AbstractImageCopyWith<$Res> {
  _$AbstractImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AbstractImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileImage = null,
    Object? thumbnail = freezed,
    Object? md5Hash = freezed,
    Object? relativeSelectionCoordinates = freezed,
  }) {
    return _then(_value.copyWith(
      fileImage: null == fileImage
          ? _value.fileImage
          : fileImage // ignore: cast_nullable_to_non_nullable
              as FileImage,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as FileImage?,
      md5Hash: freezed == md5Hash
          ? _value.md5Hash
          : md5Hash // ignore: cast_nullable_to_non_nullable
              as String?,
      relativeSelectionCoordinates: freezed == relativeSelectionCoordinates
          ? _value.relativeSelectionCoordinates
          : relativeSelectionCoordinates // ignore: cast_nullable_to_non_nullable
              as List<Offset>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AbstractImageImplCopyWith<$Res>
    implements $AbstractImageCopyWith<$Res> {
  factory _$$AbstractImageImplCopyWith(
          _$AbstractImageImpl value, $Res Function(_$AbstractImageImpl) then) =
      __$$AbstractImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@FileImageConverter() FileImage fileImage,
      @NullableFileImageConverter() FileImage? thumbnail,
      String? md5Hash,
      @OffsetListConverter() List<Offset>? relativeSelectionCoordinates});
}

/// @nodoc
class __$$AbstractImageImplCopyWithImpl<$Res>
    extends _$AbstractImageCopyWithImpl<$Res, _$AbstractImageImpl>
    implements _$$AbstractImageImplCopyWith<$Res> {
  __$$AbstractImageImplCopyWithImpl(
      _$AbstractImageImpl _value, $Res Function(_$AbstractImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of AbstractImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileImage = null,
    Object? thumbnail = freezed,
    Object? md5Hash = freezed,
    Object? relativeSelectionCoordinates = freezed,
  }) {
    return _then(_$AbstractImageImpl(
      fileImage: null == fileImage
          ? _value.fileImage
          : fileImage // ignore: cast_nullable_to_non_nullable
              as FileImage,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as FileImage?,
      md5Hash: freezed == md5Hash
          ? _value.md5Hash
          : md5Hash // ignore: cast_nullable_to_non_nullable
              as String?,
      relativeSelectionCoordinates: freezed == relativeSelectionCoordinates
          ? _value._relativeSelectionCoordinates
          : relativeSelectionCoordinates // ignore: cast_nullable_to_non_nullable
              as List<Offset>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$AbstractImageImpl extends _AbstractImage {
  const _$AbstractImageImpl(
      {@FileImageConverter() required this.fileImage,
      @NullableFileImageConverter() this.thumbnail,
      this.md5Hash,
      @OffsetListConverter() final List<Offset>? relativeSelectionCoordinates})
      : _relativeSelectionCoordinates = relativeSelectionCoordinates,
        super._();

  factory _$AbstractImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbstractImageImplFromJson(json);

  @override
  @FileImageConverter()
  final FileImage fileImage;
  @override
  @NullableFileImageConverter()
  final FileImage? thumbnail;
  @override
  final String? md5Hash;
  final List<Offset>? _relativeSelectionCoordinates;
  @override
  @OffsetListConverter()
  List<Offset>? get relativeSelectionCoordinates {
    final value = _relativeSelectionCoordinates;
    if (value == null) return null;
    if (_relativeSelectionCoordinates is EqualUnmodifiableListView)
      return _relativeSelectionCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AbstractImage(fileImage: $fileImage, thumbnail: $thumbnail, md5Hash: $md5Hash, relativeSelectionCoordinates: $relativeSelectionCoordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbstractImageImpl &&
            (identical(other.fileImage, fileImage) ||
                other.fileImage == fileImage) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.md5Hash, md5Hash) || other.md5Hash == md5Hash) &&
            const DeepCollectionEquality().equals(
                other._relativeSelectionCoordinates,
                _relativeSelectionCoordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fileImage, thumbnail, md5Hash,
      const DeepCollectionEquality().hash(_relativeSelectionCoordinates));

  /// Create a copy of AbstractImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AbstractImageImplCopyWith<_$AbstractImageImpl> get copyWith =>
      __$$AbstractImageImplCopyWithImpl<_$AbstractImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AbstractImageImplToJson(
      this,
    );
  }
}

abstract class _AbstractImage extends AbstractImage {
  const factory _AbstractImage(
      {@FileImageConverter() required final FileImage fileImage,
      @NullableFileImageConverter() final FileImage? thumbnail,
      final String? md5Hash,
      @OffsetListConverter()
      final List<Offset>? relativeSelectionCoordinates}) = _$AbstractImageImpl;
  const _AbstractImage._() : super._();

  factory _AbstractImage.fromJson(Map<String, dynamic> json) =
      _$AbstractImageImpl.fromJson;

  @override
  @FileImageConverter()
  FileImage get fileImage;
  @override
  @NullableFileImageConverter()
  FileImage? get thumbnail;
  @override
  String? get md5Hash;
  @override
  @OffsetListConverter()
  List<Offset>? get relativeSelectionCoordinates;

  /// Create a copy of AbstractImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AbstractImageImplCopyWith<_$AbstractImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
