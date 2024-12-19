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
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO make this whole thing widgets instead of funcitons
class ConvexHullImageSelector extends ConsumerStatefulWidget {
  const ConvexHullImageSelector({super.key});

  @override
  ConsumerState<ConvexHullImageSelector> createState() => _ConvexHullResultsState();
}

class _ConvexHullResultsState extends ConsumerState<ConvexHullImageSelector> {
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
                String? name = convexHullImages[index].baseName(convexHullConfig);
                logger.i(stopwatch.elapsed);
                return Column(
                  children: [
                    _ImageSetWidget(
                      key: name != null ? Key(name) : UniqueKey(),
                      imageSet: convexHullImages[index],
                      convexHullConfig: convexHullConfig,
                      cardSize: cardSize,
                      width: width,
                    ),
                    index < convexHullImages.length - 1 ? const Divider(color: Colors.white) : Container(),
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
    super.key,
  });

  List<Widget> buildNameRow({
    required List<String> proteinNames,
    required List<Color> proteinColors,
  }) {
    List<Widget> names = [];

    for (int i = 0; i < proteinNames.length; i++) {
      names.add(Text(
        proteinNames[i],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: proteinColors[i],
          fontWeight: FontWeight.w500,
        ),
      ));
    }

    names.insert(
      0,
      const SizedBox(width: 8.0),
    );
    return names;
  }

  List<Widget> buildImageRow({
    required List<String> searchPatterns,
    required ConvexHullImageSet imageSet,
    required ConvexHullConfigModel model,
    required WidgetRef ref,
  }) {
    final images = imageSet.images ?? [];
    List<Widget> widgets = [
      SizedBox(
        height: cardSize,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            imageSet.baseName(model) ?? '',
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
              key: Key(images[index].hashCode.toString()),
              image: images[index],
              callback: () {
                ref.read(appDataProvider.notifier).selectImage(image: images[index]);
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
    required Map<String, dynamic>? data,
    required WidgetRef ref,
  }) {
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
              key: Key(images[index].hashCode.toString()),
              image: images[index],
              callback: () {
                ref.read(appDataProvider.notifier).selectImage(image: images[index]);
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
    final simplexIndex = images.indexWhere((image) => image.name.endsWith(convexHullTag));
    final infiltrationIndex = images.indexWhere((image) => image.name.endsWith(infiltrationTag));

    AbstractImage? simplex;
    AbstractImage? inflammation;
    AbstractImage? infiltration;

    if (simplexIndex != -1) {
      simplex = images[simplexIndex];
    }

    if (infiltrationIndex != -1) {
      infiltration = images[infiltrationIndex];
    }
    if (simplex != null) {
      widgets.removeLast();
      final results = ConvexHullResults(
        simplex: simplex,
        inflammation: inflammation,
        infiltration: infiltration,
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
    List<Color> proteinColors = searchPatterns.map((name) {
      final colorConfig = convexHullConfig.searchPatternOverlayColorConfig;
      final validation = convexHullConfig.searchPatternOverlayConfig;
      if (validation[name] ?? false) {
        return Color(colorConfig[name] ?? 0);
      } else {
        return Colors.white;
      }
    }).toList();
    Map<int, TableColumnWidth> columnWidths = {0: const FixedColumnWidth(32)};
    for (int i = 1; i <= proteinNames.length; i++) {
      columnWidths[i] = const IntrinsicColumnWidth();
    }

    final asyncValue = ref.watch(convexHullDataProvider);

    return asyncValue.when(
      data: (data) {
        Map<String, dynamic> imageData = Map<String, dynamic>.from(data[imageSet.baseName(convexHullConfig)] ?? {});
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
                      proteinColors: proteinColors,
                    ),
                  ),
                  TableRow(
                    children: buildImageRow(
                      searchPatterns: searchPatterns,
                      imageSet: imageSet,
                      model: convexHullConfig,
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
        return const Text('error');
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
