// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convex_hull_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConvexHullStateImpl _$$ConvexHullStateImplFromJson(
        Map<String, dynamic> json) =>
    _$ConvexHullStateImpl(
      step: $enumDecodeNullable(_$ConvexHullStepEnumMap, json['step']) ??
          ConvexHullStep.first,
    );

Map<String, dynamic> _$$ConvexHullStateImplToJson(
        _$ConvexHullStateImpl instance) =>
    <String, dynamic>{
      'step': _$ConvexHullStepEnumMap[instance.step]!,
    };

const _$ConvexHullStepEnumMap = {
  ConvexHullStep.first: 'first',
  ConvexHullStep.second: 'second',
};
