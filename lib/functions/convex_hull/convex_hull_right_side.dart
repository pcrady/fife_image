import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_algorithm_description.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_display.dart';
import 'package:fife_image/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullRightSide extends ConsumerStatefulWidget {
  const ConvexHullRightSide({super.key});

  @override
  ConsumerState createState() => _ConvexHullRightSideState();
}

class _ConvexHullRightSideState extends ConsumerState<ConvexHullRightSide> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(convexHullConfigProvider);
    final leftMenu = settings.leftMenuEnum;

    return Column(
      children: [
        switch (leftMenu) {
          LeftMenuEnum.functionSettings => const ConvexHullAlgorithmDescription(),
          LeftMenuEnum.functionImageSelection => const ConvexHullDisplay(),
        }
      ],
    );
  }
}
