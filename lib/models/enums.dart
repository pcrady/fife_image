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
  functionResults,
}

enum ConvexHullStep {
  channel1BackgroundSelect,
  channel2BackgroundSelect,
  channel3BackgroundSelect,
  channel4BackgroundSelect,
  isletCropping,
  complete,
}
