import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_card.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullResultsInterface extends ConsumerStatefulWidget {
  const ConvexHullResultsInterface({super.key});

  @override
  ConsumerState<ConvexHullResultsInterface> createState() => _ConvexHullResultsState();
}

class _ConvexHullResultsState extends ConsumerState<ConvexHullResultsInterface> {
  @override
  Widget build(BuildContext context) {
    final convexHullImages = ref.watch(convexHullImageSetsProvider);
    final convexHullConfig = ref.watch(convexHullConfigProvider);

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.widthConstraints().maxWidth;
      const cardSize = 150.0;

      return SizedBox(
        width: width,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: convexHullImages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _ImageSetWidget(
                      imageSet: convexHullImages[index],
                      convexHullConfig: convexHullConfig,
                      cardSize: cardSize,
                      width: width,
                    ),
                    index < convexHullImages.length - 1 ? const Divider(color: Colors.black) : Container(),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class _ImageSetWidget extends ConsumerWidget {
  final ConvexHullImageSet imageSet;
  final ConvexHullConfigModel convexHullConfig;
  final double cardSize;
  final double width;

  const _ImageSetWidget({
    required this.imageSet,
    required this.convexHullConfig,
    required this.cardSize,
    required this.width,
  });

  List<Widget> buildNameRow({required List<String> proteinNames}) {
    List<Widget> names = proteinNames.map<Widget>((name) => Text(name, textAlign: TextAlign.center)).toList();
    names.insert(
      0,
      Container(
        color: Colors.red,
        width: 8.0,
      ),
    );
    return names;
  }

  List<Widget> buildImageRow({
    required List<String> searchPatterns,
    required ConvexHullImageSet imageSet,
    required WidgetRef ref,
  }) {
    final images = imageSet.images ?? [];
    List<Widget> widgets = [
      SizedBox(
        height: cardSize,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            imageSet.baseName ?? '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
    for (final pattern in searchPatterns) {
      final index = images.indexWhere((image) => image.name.contains(pattern) && !image.name.contains('bg_correct'));
      if (index >= 0) {
        widgets.add(
          SizedBox(
            height: cardSize,
            width: cardSize,
            child: ImageThumbnailCard(
              image: images[index],
              callback: () {
                ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: images[index]);
              },
            ),
          ),
        );
      } else {
        widgets.add(SizedBox(
          height: cardSize,
          width: cardSize,
        ));
      }
    }
    return widgets;
  }

  List<Widget> buildResultsRow({
    required List<String> searchPatterns,
    required ConvexHullImageSet imageSet,
    required Map<String, double>? data,
    required WidgetRef ref,
  }) {
    logger.i(imageSet.toJson());
    final images = imageSet.images ?? [];
    List<Widget> widgets = [
      SizedBox(
        height: cardSize,
        child: const RotatedBox(
          quarterTurns: 3,
          child: Text(
            'Results',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
    for (final pattern in searchPatterns) {
      final index = images.indexWhere((image) => image.name.contains(pattern) && image.name.contains(bgTag));
      if (index >= 0) {
        widgets.add(
          SizedBox(
            height: cardSize,
            width: cardSize,
            child: ImageThumbnailCard(
              image: images[index],
              callback: () {
                ref.read(convexHullConfigProvider.notifier).setActiveImage(activeImage: images[index]);
              },
            ),
          ),
        );
      } else {
        widgets.add(
          SizedBox(
            height: cardSize,
            width: cardSize,
          ),
        );
      }
    }
    final simplexIndex = images.indexWhere((image) => image.name.contains('simplex'));
    final inflammationIndex = images.indexWhere((image) => image.name.contains('inflammation'));
    AbstractImage? simplex;
    AbstractImage? inflammation;

    if (simplexIndex != -1) {
      simplex = images[simplexIndex];
    }
    if (inflammationIndex != -1) {
      inflammation = images[inflammationIndex];
    }
    if (simplex != null) {
      widgets.removeLast();
      final results = ConvexHullResults(
        simplex: simplex,
        inflammation: inflammation,
        data: data,
      );
      widgets.add(
        SizedBox(
          height: cardSize,
          width: cardSize,
          child: ConvexHullCard(results: results),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = convexHullConfig.searchPatternProteinConfig;
    final searchPatterns = [...config.keys, convexHullConfig.overlaySearchPattern];
    final proteinNames = [...config.values, 'Overlay'];
    Map<int, TableColumnWidth> columnWidths = {0: const FixedColumnWidth(32)};
    for (int i = 1; i <= proteinNames.length; i++) {
      columnWidths[i] = const IntrinsicColumnWidth();
    }

    final asyncValue = ref.watch(convexHullDataProvider);

    return asyncValue.when(
      data: (data) {
        logger.w(data[imageSet.baseName]);

        Map<String, double> imageData = Map<String, double>.from(data[imageSet.baseName] ?? {});

        return SizedBox(
          width: width,
          child: ScrollConfiguration(
            behavior: DraggableScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: columnWidths,
                children: [
                  TableRow(
                    children: buildNameRow(
                      proteinNames: proteinNames,
                    ),
                  ),
                  TableRow(
                    children: buildImageRow(
                      searchPatterns: searchPatterns,
                      imageSet: imageSet,
                      ref: ref,
                    ),
                  ),
                  TableRow(
                    children: buildResultsRow(
                      searchPatterns: searchPatterns,
                      imageSet: imageSet,
                      data: imageData,
                      ref: ref,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (err, stack) {
        logger.e(err, stackTrace: stack);
        return Text('error');
      },
      loading: () => Container(),
    );
  }
}

class DraggableScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
