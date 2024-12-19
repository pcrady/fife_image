import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_top_buttons.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_image_selector.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_settings.dart';
import 'package:fife_image/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullLeftSide extends ConsumerStatefulWidget {
  const ConvexHullLeftSide({super.key});

  @override
  ConsumerState createState() => _ConvexHullLeftSideState();
}

class _ConvexHullLeftSideState extends ConsumerState<ConvexHullLeftSide> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(convexHullConfigProvider);
    final leftMenu = settings.leftMenuEnum;

    if (leftMenu == LeftMenuEnum.functionSettings) {
      return RawScrollbar(
        thumbColor: Colors.white30,
        controller: scrollController,
        radius: const Radius.circular(20),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const SizedBox(height: 4.0),
              const ConvexHullTopButtons(),
              const SizedBox(height: 8.0),
              switch (leftMenu) {
                LeftMenuEnum.functionSettings => const ConvexHullSettings(),
                LeftMenuEnum.functionImageSelection => const Expanded(child: ConvexHullImageSelector()),
              }
            ],
          ),
        ),
      );
    }

    return const Column(
      children: [
        SizedBox(height: 4.0),
        ConvexHullTopButtons(),
        SizedBox(height: 8.0),
        Expanded(child: ConvexHullImageSelector()),
      ],
    );
  }
}
