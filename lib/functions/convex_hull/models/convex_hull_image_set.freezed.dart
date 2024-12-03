// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convex_hull_image_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvexHullImageSet _$ConvexHullImageSetFromJson(Map<String, dynamic> json) {
  return _ConvexHullImageSet.fromJson(json);
}

/// @nodoc
mixin _$ConvexHullImageSet {
//String? baseName,
  List<AbstractImage>? get images => throw _privateConstructorUsedError;
  ConvexHullResults get results => throw _privateConstructorUsedError;

  /// Serializes this ConvexHullImageSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConvexHullImageSetCopyWith<ConvexHullImageSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvexHullImageSetCopyWith<$Res> {
  factory $ConvexHullImageSetCopyWith(
          ConvexHullImageSet value, $Res Function(ConvexHullImageSet) then) =
      _$ConvexHullImageSetCopyWithImpl<$Res, ConvexHullImageSet>;
  @useResult
  $Res call({List<AbstractImage>? images, ConvexHullResults results});

  $ConvexHullResultsCopyWith<$Res> get results;
}

/// @nodoc
class _$ConvexHullImageSetCopyWithImpl<$Res, $Val extends ConvexHullImageSet>
    implements $ConvexHullImageSetCopyWith<$Res> {
  _$ConvexHullImageSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = freezed,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AbstractImage>?,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults,
    ) as $Val);
  }

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConvexHullResultsCopyWith<$Res> get results {
    return $ConvexHullResultsCopyWith<$Res>(_value.results, (value) {
      return _then(_value.copyWith(results: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConvexHullImageSetImplCopyWith<$Res>
    implements $ConvexHullImageSetCopyWith<$Res> {
  factory _$$ConvexHullImageSetImplCopyWith(_$ConvexHullImageSetImpl value,
          $Res Function(_$ConvexHullImageSetImpl) then) =
      __$$ConvexHullImageSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AbstractImage>? images, ConvexHullResults results});

  @override
  $ConvexHullResultsCopyWith<$Res> get results;
}

/// @nodoc
class __$$ConvexHullImageSetImplCopyWithImpl<$Res>
    extends _$ConvexHullImageSetCopyWithImpl<$Res, _$ConvexHullImageSetImpl>
    implements _$$ConvexHullImageSetImplCopyWith<$Res> {
  __$$ConvexHullImageSetImplCopyWithImpl(_$ConvexHullImageSetImpl _value,
      $Res Function(_$ConvexHullImageSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? images = freezed,
    Object? results = null,
  }) {
    return _then(_$ConvexHullImageSetImpl(
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<AbstractImage>?,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$ConvexHullImageSetImpl extends _ConvexHullImageSet {
  _$ConvexHullImageSetImpl(
      {final List<AbstractImage>? images,
      this.results = const ConvexHullResults()})
      : _images = images,
        super._();

  factory _$ConvexHullImageSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvexHullImageSetImplFromJson(json);

//String? baseName,
  final List<AbstractImage>? _images;
//String? baseName,
  @override
  List<AbstractImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final ConvexHullResults results;

  @override
  String toString() {
    return 'ConvexHullImageSet(images: $images, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvexHullImageSetImpl &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.results, results) || other.results == results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_images), results);

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvexHullImageSetImplCopyWith<_$ConvexHullImageSetImpl> get copyWith =>
      __$$ConvexHullImageSetImplCopyWithImpl<_$ConvexHullImageSetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvexHullImageSetImplToJson(
      this,
    );
  }
}

abstract class _ConvexHullImageSet extends ConvexHullImageSet {
  factory _ConvexHullImageSet(
      {final List<AbstractImage>? images,
      final ConvexHullResults results}) = _$ConvexHullImageSetImpl;
  _ConvexHullImageSet._() : super._();

  factory _ConvexHullImageSet.fromJson(Map<String, dynamic> json) =
      _$ConvexHullImageSetImpl.fromJson;

//String? baseName,
  @override
  List<AbstractImage>? get images;
  @override
  ConvexHullResults get results;

  /// Create a copy of ConvexHullImageSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConvexHullImageSetImplCopyWith<_$ConvexHullImageSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
