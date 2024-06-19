import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/convex_hull_image_provider.dart';
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
    final convexHullImages = ref.watch(convexHullImageProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullState = settings.convexHullState;
    final width = MediaQuery.of(context).size.width;
    final cardSize = (width / 2.0 / 6.0) - 16.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: cardSize),
              SizedBox(
                width: cardSize,
                child: Text(
                  convexHullState.channel1ProteinName,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: cardSize,
                child: Text(
                  convexHullState.channel2ProteinName,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: cardSize,
                child: Text(
                  convexHullState.channel3ProteinName,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: cardSize,
                child: Text(
                  convexHullState.channel4ProteinName,
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
              return _ImageSetWidget(
                imageSet: convexHullImages[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ImageSetWidget extends ConsumerWidget {
  final ImageSet imageSet;

  const _ImageSetWidget({
    required this.imageSet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final cardSize = (width / 2.0 / 6.0) - 16.0;
    final appData = ref.read(appDataProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: cardSize,
          child: Text(
            imageSet.baseName ?? '',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        imageSet.channel1 != null
            ? SizedBox(
                width: cardSize,
                height: cardSize,
                child: ImageCard(image: imageSet.channel1!),
              )
            : SizedBox(width: cardSize, height: cardSize),
        imageSet.channel2 != null
            ? SizedBox(
                width: cardSize,
                height: cardSize,
                child: ImageCard(image: imageSet.channel2!),
              )
            : SizedBox(width: cardSize, height: cardSize),
        imageSet.channel3 != null
            ? SizedBox(
                width: cardSize,
                height: cardSize,
                child: ImageCard(image: imageSet.channel3!),
              )
            : SizedBox(width: cardSize, height: cardSize),
        imageSet.channel4 != null
            ? SizedBox(
                width: cardSize,
                height: cardSize,
                child: ImageCard(image: imageSet.channel4!),
              )
            : SizedBox(width: cardSize, height: cardSize),
        imageSet.overlay != null
            ? SizedBox(
                width: cardSize,
                height: cardSize,
                child: ImageCard(image: imageSet.overlay!),
              )
            : SizedBox(width: cardSize, height: cardSize),
      ],
    );
  }
}
