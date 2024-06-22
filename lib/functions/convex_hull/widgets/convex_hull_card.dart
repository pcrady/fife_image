import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final config = ref.watch(convexHullConfigProvider);

    if (image != null) {
      return ImageThumbnailCard(
        image: image!,
        callback: () {
          ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: image!);
        },
        deleteCallback: () {
          if (ref.read(convexHullConfigProvider).activeImage == image) {
            ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: null);
          }
        },
      );
    } else if (results != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            ref.read(convexHullConfigProvider.notifier).setActiveResults(results: results!);
          },
          child: Card(
            shape: config.activeResults == results
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(
                      color: Colors.green,
                      width: 4.0,
                    ),
                  )
                : null,
            color: Colors.purpleAccent,
            clipBehavior: Clip.antiAlias,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.flaskVial),
                Text(
                  'Results',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
