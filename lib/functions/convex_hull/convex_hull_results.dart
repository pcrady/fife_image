import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullResults extends ConsumerStatefulWidget {
  const ConvexHullResults({super.key});

  @override
  ConsumerState<ConvexHullResults> createState() => _ConvexHullResultsState();
}

class _ConvexHullResultsState extends ConsumerState<ConvexHullResults> {
  @override
  Widget build(BuildContext context) {
    final convexHullImages = ref.watch(convexHullImageSetsProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullConfig = settings.convexHullConfig;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.widthConstraints().maxWidth;
      final cardSize = (width - 20) / 6.0;

      return SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  SizedBox(
                    width: cardSize,
                    child: Text(
                      convexHullConfig.channel0ProteinName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: cardSize,
                    child: Text(
                      convexHullConfig.channel1ProteinName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: cardSize,
                    child: Text(
                      convexHullConfig.channel2ProteinName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: cardSize,
                    child: Text(
                      convexHullConfig.channel3ProteinName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: cardSize,
                    child: Text(
                      convexHullConfig.channel4ProteinName,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: cardSize,
                    child: const Text(
                      'Overlay',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: convexHullImages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _ImageSetWidget(
                        imageSet: convexHullImages[index],
                        cardSize: cardSize,
                      ),
                      index < convexHullImages.length - 1 ? const Divider(color: Colors.black) : Container(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ImageSetWidget extends ConsumerWidget {
  final ConvexHullImageSet imageSet;
  final double cardSize;

  const _ImageSetWidget({
    required this.imageSet,
    required this.cardSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text(imageSet.baseName ?? ''),
            ),
            imageSet.channel0 != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel0!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel1 != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel1!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel2 != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel2!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel3 != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel3!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel4 != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel4!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.overlay != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.overlay!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const RotatedBox(
              quarterTurns: 3,
              child: Text('Results'),
            ),
            imageSet.channel0BackgroundCorrect != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel0BackgroundCorrect!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel1BackgroundCorrect != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel1BackgroundCorrect!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel2BackgroundCorrect != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel2BackgroundCorrect!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel3BackgroundCorrect != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel3BackgroundCorrect!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.channel4BackgroundCorrect != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.channel4BackgroundCorrect!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
            imageSet.inflammation != null
                ? SizedBox(
                    width: cardSize,
                    height: cardSize,
                    child: ImageThumbnailCard(image: imageSet.inflammation!),
                  )
                : SizedBox(width: cardSize, height: cardSize),
          ],
        ),
      ],
    );
  }
}
