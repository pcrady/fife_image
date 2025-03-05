import 'package:fife_image/functions/convex_hull/convex_hull_left_side.dart';
import 'package:fife_image/functions/convex_hull/convex_hull_right_side.dart';
import 'package:fife_image/functions/no_function/no_function_left_side.dart';
import 'package:fife_image/functions/no_function/no_function_right_side.dart';
import 'package:flutter/material.dart';

enum FunctionsEnum {
  functions,
  convexHull;

  String get name {
    switch (this) {
      case FunctionsEnum.functions:
        return 'Functions';
      case FunctionsEnum.convexHull:
        return 'Convex Hull';
    }
  }

  Widget get leftSide {
    switch (this) {
      case FunctionsEnum.functions:
        return const NoFunctionLeftSide();
      case FunctionsEnum.convexHull:
        return const ConvexHullLeftSide();
    }
  }

  Widget get rightSide {
    switch (this) {
      case FunctionsEnum.functions:
        return const NoFunctionRightSide();
      case FunctionsEnum.convexHull:
        return const ConvexHullRightSide();
    }
  }
}