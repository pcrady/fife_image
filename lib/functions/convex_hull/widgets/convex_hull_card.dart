import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:fife_image/widgets/results_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullCard extends ConsumerWidget {
  final AbstractImage? image;
  final ConvexHullResults? results;

  const ConvexHullCard({
    this.image,
    this.results,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    if (image != null) {
      return ImageThumbnailCard(
        image: image!,
        callback: () {
          ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: image!);
        },
      );
    } else if (results != null) {
      return ResultsCard(
        callback: () {
          ref.read(convexHullConfigProvider.notifier).setActiveResults(results: results!);
        },
      );
    }
    return Container();
  }
}
