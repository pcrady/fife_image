import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConvexHullCard extends ConsumerStatefulWidget {
  final AbstractImage? image;
  final ConvexHullResults? results;
  final void Function()? deleteCallback;

  const ConvexHullCard({
    this.image,
    this.results,
    this.deleteCallback,
    super.key,
  });

  @override
  ConsumerState createState() => _ConvexHullCardState();
}

class _ConvexHullCardState extends ConsumerState<ConvexHullCard> {
  bool mouseHover = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(convexHullConfigProvider);

    if (widget.image != null) {
      return ImageThumbnailCard(
        image: widget.image!,
        callback: () {
          ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: widget.image!);
        },
        deleteCallback: () {
          if (ref.read(convexHullConfigProvider).activeImage == widget.image) {
            ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: null);
          }
        },
      );
    } else if (widget.results != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => mouseHover = true);
        },
        onExit: (_) {
          setState(() => mouseHover = false);
        },
        child: GestureDetector(
          onTap: () {
            ref.read(convexHullConfigProvider.notifier).setActiveResults(results: widget.results!);
          },
          child: Card(
            shape: config.activeResults == widget.results
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Column(
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
                mouseHover
                    ? Positioned(
                        right: 4.0,
                        top: 4.0,
                        child: GestureDetector(
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onTap: () async {
                            final images = ref.read(imagesProvider.notifier);
                            final inflammation = widget.results?.inflammation;
                            final simplex = widget.results?.simplex;
                            List<Future> futures = [];
                            if (inflammation != null) futures.add(images.deleteImageFromServer(image: inflammation));
                            if (simplex != null) futures.add(images.deleteImageFromServer(image: simplex));
                            await Future.wait(futures);
                            
                            if (ref.read(convexHullConfigProvider).activeResults == widget.results) {
                              ref.read(convexHullConfigProvider.notifier).setActiveResults(results: null);
                            }
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
