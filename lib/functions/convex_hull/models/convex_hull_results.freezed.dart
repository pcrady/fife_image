// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convex_hull_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvexHullResults _$ConvexHullResultsFromJson(Map<String, dynamic> json) {
  return _ConvexHullResults.fromJson(json);
}

/// @nodoc
mixin _$ConvexHullResults {
  AbstractImage? get inflammation => throw _privateConstructorUsedError;
  AbstractImage? get simplex => throw _privateConstructorUsedError;
  Map<String, String>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConvexHullResultsCopyWith<ConvexHullResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvexHullResultsCopyWith<$Res> {
  factory $ConvexHullResultsCopyWith(
          ConvexHullResults value, $Res Function(ConvexHullResults) then) =
      _$ConvexHullResultsCopyWithImpl<$Res, ConvexHullResults>;
  @useResult
  $Res call(
      {AbstractImage? inflammation,
      AbstractImage? simplex,
      Map<String, String>? data});

  $AbstractImageCopyWith<$Res>? get inflammation;
  $AbstractImageCopyWith<$Res>? get simplex;
}

/// @nodoc
class _$ConvexHullResultsCopyWithImpl<$Res, $Val extends ConvexHullResults>
    implements $ConvexHullResultsCopyWith<$Res> {
  _$ConvexHullResultsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inflammation = freezed,
    Object? simplex = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      inflammation: freezed == inflammation
          ? _value.inflammation
          : inflammation // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      simplex: freezed == simplex
          ? _value.simplex
          : simplex // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AbstractImageCopyWith<$Res>? get inflammation {
    if (_value.inflammation == null) {
      return null;
    }

    return $AbstractImageCopyWith<$Res>(_value.inflammation!, (value) {
      return _then(_value.copyWith(inflammation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AbstractImageCopyWith<$Res>? get simplex {
    if (_value.simplex == null) {
      return null;
    }

    return $AbstractImageCopyWith<$Res>(_value.simplex!, (value) {
      return _then(_value.copyWith(simplex: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConvexHullResultsImplCopyWith<$Res>
    implements $ConvexHullResultsCopyWith<$Res> {
  factory _$$ConvexHullResultsImplCopyWith(_$ConvexHullResultsImpl value,
          $Res Function(_$ConvexHullResultsImpl) then) =
      __$$ConvexHullResultsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AbstractImage? inflammation,
      AbstractImage? simplex,
      Map<String, String>? data});

  @override
  $AbstractImageCopyWith<$Res>? get inflammation;
  @override
  $AbstractImageCopyWith<$Res>? get simplex;
}

/// @nodoc
class __$$ConvexHullResultsImplCopyWithImpl<$Res>
    extends _$ConvexHullResultsCopyWithImpl<$Res, _$ConvexHullResultsImpl>
    implements _$$ConvexHullResultsImplCopyWith<$Res> {
  __$$ConvexHullResultsImplCopyWithImpl(_$ConvexHullResultsImpl _value,
      $Res Function(_$ConvexHullResultsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inflammation = freezed,
    Object? simplex = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ConvexHullResultsImpl(
      inflammation: freezed == inflammation
          ? _value.inflammation
          : inflammation // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      simplex: freezed == simplex
          ? _value.simplex
          : simplex // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$ConvexHullResultsImpl extends _ConvexHullResults {
  const _$ConvexHullResultsImpl(
      {this.inflammation, this.simplex, final Map<String, String>? data})
      : _data = data,
        super._();

  factory _$ConvexHullResultsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvexHullResultsImplFromJson(json);

  @override
  final AbstractImage? inflammation;
  @override
  final AbstractImage? simplex;
  final Map<String, String>? _data;
  @override
  Map<String, String>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ConvexHullResults(inflammation: $inflammation, simplex: $simplex, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvexHullResultsImpl &&
            (identical(other.inflammation, inflammation) ||
                other.inflammation == inflammation) &&
            (identical(other.simplex, simplex) || other.simplex == simplex) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, inflammation, simplex,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvexHullResultsImplCopyWith<_$ConvexHullResultsImpl> get copyWith =>
      __$$ConvexHullResultsImplCopyWithImpl<_$ConvexHullResultsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvexHullResultsImplToJson(
      this,
    );
  }
}

abstract class _ConvexHullResults extends ConvexHullResults {
  const factory _ConvexHullResults(
      {final AbstractImage? inflammation,
      final AbstractImage? simplex,
      final Map<String, String>? data}) = _$ConvexHullResultsImpl;
  const _ConvexHullResults._() : super._();

  factory _ConvexHullResults.fromJson(Map<String, dynamic> json) =
      _$ConvexHullResultsImpl.fromJson;

  @override
  AbstractImage? get inflammation;
  @override
  AbstractImage? get simplex;
  @override
  Map<String, String>? get data;
  @override
  @JsonKey(ignore: true)
  _$$ConvexHullResultsImplCopyWith<_$ConvexHullResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
