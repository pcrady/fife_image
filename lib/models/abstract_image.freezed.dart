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
  String? get imagePath => throw _privateConstructorUsedError;
  String? get md5Hash => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get file => throw _privateConstructorUsedError;
  @OffsetListConverter()
  List<Offset>? get relativeSelectionCoordinates =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
      {String? imagePath,
      String? md5Hash,
      @Uint8ListConverter() Uint8List? file,
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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? md5Hash = freezed,
    Object? file = freezed,
    Object? relativeSelectionCoordinates = freezed,
  }) {
    return _then(_value.copyWith(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      md5Hash: freezed == md5Hash
          ? _value.md5Hash
          : md5Hash // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
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
      {String? imagePath,
      String? md5Hash,
      @Uint8ListConverter() Uint8List? file,
      @OffsetListConverter() List<Offset>? relativeSelectionCoordinates});
}

/// @nodoc
class __$$AbstractImageImplCopyWithImpl<$Res>
    extends _$AbstractImageCopyWithImpl<$Res, _$AbstractImageImpl>
    implements _$$AbstractImageImplCopyWith<$Res> {
  __$$AbstractImageImplCopyWithImpl(
      _$AbstractImageImpl _value, $Res Function(_$AbstractImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? md5Hash = freezed,
    Object? file = freezed,
    Object? relativeSelectionCoordinates = freezed,
  }) {
    return _then(_$AbstractImageImpl(
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      md5Hash: freezed == md5Hash
          ? _value.md5Hash
          : md5Hash // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
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
      {this.imagePath,
      this.md5Hash,
      @Uint8ListConverter() this.file,
      @OffsetListConverter() final List<Offset>? relativeSelectionCoordinates})
      : _relativeSelectionCoordinates = relativeSelectionCoordinates,
        super._();

  factory _$AbstractImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AbstractImageImplFromJson(json);

  @override
  final String? imagePath;
  @override
  final String? md5Hash;
  @override
  @Uint8ListConverter()
  final Uint8List? file;
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
    return 'AbstractImage(imagePath: $imagePath, md5Hash: $md5Hash, file: $file, relativeSelectionCoordinates: $relativeSelectionCoordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AbstractImageImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.md5Hash, md5Hash) || other.md5Hash == md5Hash) &&
            const DeepCollectionEquality().equals(other.file, file) &&
            const DeepCollectionEquality().equals(
                other._relativeSelectionCoordinates,
                _relativeSelectionCoordinates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      imagePath,
      md5Hash,
      const DeepCollectionEquality().hash(file),
      const DeepCollectionEquality().hash(_relativeSelectionCoordinates));

  @JsonKey(ignore: true)
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
      {final String? imagePath,
      final String? md5Hash,
      @Uint8ListConverter() final Uint8List? file,
      @OffsetListConverter()
      final List<Offset>? relativeSelectionCoordinates}) = _$AbstractImageImpl;
  const _AbstractImage._() : super._();

  factory _AbstractImage.fromJson(Map<String, dynamic> json) =
      _$AbstractImageImpl.fromJson;

  @override
  String? get imagePath;
  @override
  String? get md5Hash;
  @override
  @Uint8ListConverter()
  Uint8List? get file;
  @override
  @OffsetListConverter()
  List<Offset>? get relativeSelectionCoordinates;
  @override
  @JsonKey(ignore: true)
  _$$AbstractImageImplCopyWith<_$AbstractImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
