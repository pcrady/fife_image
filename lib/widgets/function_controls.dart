import 'package:fife_image/functions/convex_hull/convex_hull_controls.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionControls extends ConsumerWidget {
  const FunctionControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appDataProvider);
    if (settings.function == FunctionsEnum.convexHull) {
      return const ConvexHullControls();
    } else {
      return Container();
    }
  }
}
