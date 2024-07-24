// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convex_hull_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvexHullDataModel _$ConvexHullDataModelFromJson(Map<String, dynamic> json) {
  return _ConvexHullDataModel.fromJson(json);
}

/// @nodoc
mixin _$ConvexHullDataModel {
  double? get totalImageArea => throw _privateConstructorUsedError;
  double? get totalIsletArea => throw _privateConstructorUsedError;
  Map<String, double>? get data => throw _privateConstructorUsedError;

  /// Serializes this ConvexHullDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConvexHullDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConvexHullDataModelCopyWith<ConvexHullDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvexHullDataModelCopyWith<$Res> {
  factory $ConvexHullDataModelCopyWith(
          ConvexHullDataModel value, $Res Function(ConvexHullDataModel) then) =
      _$ConvexHullDataModelCopyWithImpl<$Res, ConvexHullDataModel>;
  @useResult
  $Res call(
      {double? totalImageArea,
      double? totalIsletArea,
      Map<String, double>? data});
}

/// @nodoc
class _$ConvexHullDataModelCopyWithImpl<$Res, $Val extends ConvexHullDataModel>
    implements $ConvexHullDataModelCopyWith<$Res> {
  _$ConvexHullDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConvexHullDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalImageArea = freezed,
    Object? totalIsletArea = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      totalImageArea: freezed == totalImageArea
          ? _value.totalImageArea
          : totalImageArea // ignore: cast_nullable_to_non_nullable
              as double?,
      totalIsletArea: freezed == totalIsletArea
          ? _value.totalIsletArea
          : totalIsletArea // ignore: cast_nullable_to_non_nullable
              as double?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConvexHullDataModelImplCopyWith<$Res>
    implements $ConvexHullDataModelCopyWith<$Res> {
  factory _$$ConvexHullDataModelImplCopyWith(_$ConvexHullDataModelImpl value,
          $Res Function(_$ConvexHullDataModelImpl) then) =
      __$$ConvexHullDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? totalImageArea,
      double? totalIsletArea,
      Map<String, double>? data});
}

/// @nodoc
class __$$ConvexHullDataModelImplCopyWithImpl<$Res>
    extends _$ConvexHullDataModelCopyWithImpl<$Res, _$ConvexHullDataModelImpl>
    implements _$$ConvexHullDataModelImplCopyWith<$Res> {
  __$$ConvexHullDataModelImplCopyWithImpl(_$ConvexHullDataModelImpl _value,
      $Res Function(_$ConvexHullDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConvexHullDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalImageArea = freezed,
    Object? totalIsletArea = freezed,
    Object? data = freezed,
  }) {
    return _then(_$ConvexHullDataModelImpl(
      totalImageArea: freezed == totalImageArea
          ? _value.totalImageArea
          : totalImageArea // ignore: cast_nullable_to_non_nullable
              as double?,
      totalIsletArea: freezed == totalIsletArea
          ? _value.totalIsletArea
          : totalIsletArea // ignore: cast_nullable_to_non_nullable
              as double?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$ConvexHullDataModelImpl implements _ConvexHullDataModel {
  const _$ConvexHullDataModelImpl(
      {this.totalImageArea,
      this.totalIsletArea,
      final Map<String, double>? data})
      : _data = data;

  factory _$ConvexHullDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvexHullDataModelImplFromJson(json);

  @override
  final double? totalImageArea;
  @override
  final double? totalIsletArea;
  final Map<String, double>? _data;
  @override
  Map<String, double>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ConvexHullDataModel(totalImageArea: $totalImageArea, totalIsletArea: $totalIsletArea, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvexHullDataModelImpl &&
            (identical(other.totalImageArea, totalImageArea) ||
                other.totalImageArea == totalImageArea) &&
            (identical(other.totalIsletArea, totalIsletArea) ||
                other.totalIsletArea == totalIsletArea) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalImageArea, totalIsletArea,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of ConvexHullDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvexHullDataModelImplCopyWith<_$ConvexHullDataModelImpl> get copyWith =>
      __$$ConvexHullDataModelImplCopyWithImpl<_$ConvexHullDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvexHullDataModelImplToJson(
      this,
    );
  }
}

abstract class _ConvexHullDataModel implements ConvexHullDataModel {
  const factory _ConvexHullDataModel(
      {final double? totalImageArea,
      final double? totalIsletArea,
      final Map<String, double>? data}) = _$ConvexHullDataModelImpl;

  factory _ConvexHullDataModel.fromJson(Map<String, dynamic> json) =
      _$ConvexHullDataModelImpl.fromJson;

  @override
  double? get totalImageArea;
  @override
  double? get totalIsletArea;
  @override
  Map<String, double>? get data;

  /// Create a copy of ConvexHullDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConvexHullDataModelImplCopyWith<_$ConvexHullDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
