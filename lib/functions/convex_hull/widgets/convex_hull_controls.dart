import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullControls extends ConsumerStatefulWidget {
  const ConvexHullControls({super.key});

  @override
  ConsumerState<ConvexHullControls> createState() => _ConvexHullControlsState();
}

class _ConvexHullControlsState extends ConsumerState<ConvexHullControls> {
  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);

    if (convexHullConfig.leftMenuEnum == LeftMenuEnum.functionResults && convexHullConfig.activeImage != null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _BackgroundSelect(),
      );
    } else if (convexHullConfig.activeResults != null) {
      return _ConvexHullResultsDisplay(results: convexHullConfig.activeResults!);
    } else {
      return Container();
    }
  }
}

class _ConvexHullResultsDisplay extends StatelessWidget {
  final ConvexHullResults results;

  const _ConvexHullResultsDisplay({
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: results.simplex!.url,
              cacheKey: results.simplex!.md5Hash,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorListener: (error) {
                logger.e(error);
              },
            ),
          ),
        ),
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              imageUrl: results.inflammation!.url,
              cacheKey: results.inflammation!.md5Hash,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorListener: (error) {
                logger.e(error);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundSelect extends ConsumerWidget {
  const _BackgroundSelect();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);
    final correctedImages = ref.read(convexHullImageSetsProvider.notifier).backgroundCorrectionImages();
    final unmodifiedImages = ref.read(convexHullImageSetsProvider.notifier).unmodifiedImages();
    final image = convexHullConfig.activeImage;

    if (correctedImages.contains(image)) {
      return Column(
        children: [
          image != null ? SelectedImage(image: image) : Container(),
        ],
      );
    } else if (unmodifiedImages.contains(image)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image != null ? SelectedImage(image: image) : Container(),
          const Text(
            'Select the region of highest background signal.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      ref.read(imagesProvider.notifier).updateSelection(image: image, selection: null);
                    }
                  },
                  child: const Text('Clear Selection'),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(convexHullImageSetsProvider.notifier).backgroundSelect();
                    } catch (err, stack) {
                      logger.e(err, stackTrace: stack);
                    }
                  },
                  child: const Text('Perform Background Correction'),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      logger.w('here');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image != null ? SelectedImage(image: image) : Container(),
          const Text(
            'Select the outline of the islet.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      ref.read(imagesProvider.notifier).updateSelection(image: image, selection: null);
                    }
                  },
                  child: const Text('Clear Selection'),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(convexHullImageSetsProvider.notifier).performCalculation();
                    } catch (err, stack) {
                      logger.e(err, stackTrace: stack);
                    }
                  },
                  child: const Text('Perform Calculations'),
                ),
              )
            ],
          ),
        ],
      );
    }
  }
}
