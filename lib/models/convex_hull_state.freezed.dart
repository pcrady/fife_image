// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convex_hull_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvexHullState _$ConvexHullStateFromJson(Map<String, dynamic> json) {
  return _ConvexHullState.fromJson(json);
}

/// @nodoc
mixin _$ConvexHullState {
  ConvexHullStep get step => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConvexHullStateCopyWith<ConvexHullState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvexHullStateCopyWith<$Res> {
  factory $ConvexHullStateCopyWith(
          ConvexHullState value, $Res Function(ConvexHullState) then) =
      _$ConvexHullStateCopyWithImpl<$Res, ConvexHullState>;
  @useResult
  $Res call({ConvexHullStep step});
}

/// @nodoc
class _$ConvexHullStateCopyWithImpl<$Res, $Val extends ConvexHullState>
    implements $ConvexHullStateCopyWith<$Res> {
  _$ConvexHullStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as ConvexHullStep,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConvexHullStateImplCopyWith<$Res>
    implements $ConvexHullStateCopyWith<$Res> {
  factory _$$ConvexHullStateImplCopyWith(_$ConvexHullStateImpl value,
          $Res Function(_$ConvexHullStateImpl) then) =
      __$$ConvexHullStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ConvexHullStep step});
}

/// @nodoc
class __$$ConvexHullStateImplCopyWithImpl<$Res>
    extends _$ConvexHullStateCopyWithImpl<$Res, _$ConvexHullStateImpl>
    implements _$$ConvexHullStateImplCopyWith<$Res> {
  __$$ConvexHullStateImplCopyWithImpl(
      _$ConvexHullStateImpl _value, $Res Function(_$ConvexHullStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
  }) {
    return _then(_$ConvexHullStateImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as ConvexHullStep,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$ConvexHullStateImpl implements _ConvexHullState {
  const _$ConvexHullStateImpl({this.step = ConvexHullStep.first});

  factory _$ConvexHullStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvexHullStateImplFromJson(json);

  @override
  @JsonKey()
  final ConvexHullStep step;

  @override
  String toString() {
    return 'ConvexHullState(step: $step)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvexHullStateImpl &&
            (identical(other.step, step) || other.step == step));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, step);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvexHullStateImplCopyWith<_$ConvexHullStateImpl> get copyWith =>
      __$$ConvexHullStateImplCopyWithImpl<_$ConvexHullStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvexHullStateImplToJson(
      this,
    );
  }
}

abstract class _ConvexHullState implements ConvexHullState {
  const factory _ConvexHullState({final ConvexHullStep step}) =
      _$ConvexHullStateImpl;

  factory _ConvexHullState.fromJson(Map<String, dynamic> json) =
      _$ConvexHullStateImpl.fromJson;

  @override
  ConvexHullStep get step;
  @override
  @JsonKey(ignore: true)
  _$$ConvexHullStateImplCopyWith<_$ConvexHullStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
