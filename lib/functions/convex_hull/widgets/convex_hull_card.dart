import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
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
    final appData = ref.watch(appDataProvider);

    if (widget.image != null) {
      return ImageThumbnailCard(
        image: widget.image!,
        callback: () {
          ref.read(appDataProvider.notifier).selectImage(image: widget.image);
        },
        deleteCallback: () {
          if (ref.read(appDataProvider).selectedImage == widget.image) {
            ref.read(appDataProvider.notifier).selectImage(image: null);
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
            ref.read(appDataProvider.notifier).setActiveResults(results: widget.results!);
          },
          child: Card(
            shape: appData.activeResults == widget.results
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  )
                : null,
            color: Colors.deepPurple,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.flaskVial,
                      size: 42.0,
                    ),
                    Text(
                      'Results',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                            final infiltration = widget.results?.infiltration;
                            List<Future> futures = [];
                            if (inflammation != null) futures.add(images.deleteImageFromServer(image: inflammation));
                            if (simplex != null) futures.add(images.deleteImageFromServer(image: simplex));
                            if (infiltration != null) futures.add(images.deleteImageFromServer(image: infiltration));
                            await Future.wait(futures);

                            if (appData.activeResults == widget.results) {
                              ref.read(appDataProvider.notifier).setActiveResults(results: null);
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
