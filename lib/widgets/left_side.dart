import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/convex_hull_results.dart';
import 'package:fife_image/widgets/convex_hull_settings.dart';
import 'package:fife_image/widgets/image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeftSide extends ConsumerWidget {
  const LeftSide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appDataProvider);

    if (settings.leftMenu == LeftMenuEnum.images) {
      return const ImageList();
    } else if (settings.leftMenu == LeftMenuEnum.functionSettings) {
      if (settings.function == FunctionsEnum.convexHull) {
        return const ConvexHullSettings();
      }
    } else if (settings.leftMenu == LeftMenuEnum.functionResults) {
      if (settings.function == FunctionsEnum.convexHull) {
        return const ConvexHullResults();
      }
    }
    return Container();
  }
}
