import 'package:fife_image/functions/convex_hull/convex_hull_left_side.dart';
import 'package:fife_image/functions/convex_hull/convex_hull_right_side.dart';
import 'package:fife_image/functions/no_function/no_function_left_side.dart';
import 'package:fife_image/functions/no_function/no_function_right_side.dart';
import 'package:flutter/material.dart';

enum FunctionsEnum {
  functions,
  convexHull,
}

extension FunctionsEnumExtension on FunctionsEnum {
  String toName() {
    if (this == FunctionsEnum.convexHull) {
      return 'Convex Hull';
    } else {
      return 'Functions';
    }
  }
}

class FifeImageFunction {
  final FunctionsEnum imageFunction;
  final Widget leftSide;
  final Widget rightSide;

  FifeImageFunction({
    required this.imageFunction,
    required this.leftSide,
    required this.rightSide,
  });
}

class NoFunction implements FifeImageFunction {
  @override
  FunctionsEnum get imageFunction => FunctionsEnum.functions;

  @override
  Widget get leftSide => const NoFunctionLeftSide();

  @override
  Widget get rightSide => const NoFunctionRightSide();
}

class ConvexHull implements FifeImageFunction {
  @override
  FunctionsEnum get imageFunction => FunctionsEnum.convexHull;

  @override
  Widget get leftSide => const ConvexHullLeftSide();

  @override
  Widget get rightSide => const ConvexHullRightSide();
}

final List<FifeImageFunction> imageFunctions = [
  NoFunction(),
  ConvexHull(),
];
