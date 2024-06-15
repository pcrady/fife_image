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

enum LeftMenuEnum {
  images,
  functionSettings,
}