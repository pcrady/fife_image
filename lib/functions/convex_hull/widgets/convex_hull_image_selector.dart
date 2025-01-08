import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/functions/convex_hull/widgets/convex_hull_card.dart';
import 'package:fife_image/functions/convex_hull/widgets/edit_image_set_dialog.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullImageSelector extends ConsumerStatefulWidget {
  const ConvexHullImageSelector({super.key});

  @override
  ConsumerState<ConvexHullImageSelector> createState() => _ConvexHullResultsState();
}

class _ConvexHullResultsState extends ConsumerState<ConvexHullImageSelector> {
  late ScrollController scrollController;
  late TextEditingController searchController;

  @override
  void initState() {
    scrollController = ScrollController();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);
    late List<ConvexHullImageSet> convexHullImages;
    if (searchController.text.trim().isEmpty) {
      convexHullImages = ref.watch(convexHullImageSetsProvider);
    } else {
      convexHullImages = ref
          .watch(convexHullImageSetsProvider)
          .where((set) => (set.baseName(convexHullConfig) ?? '').contains(searchController.text.trim()))
          .toList();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.widthConstraints().maxWidth;

      return SizedBox(
        width: width,
        child: RawScrollbar(
          thumbColor: Colors.white30,
          controller: scrollController,
          radius: const Radius.circular(20),
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Filter',
                  border: OutlineInputBorder(),
                  labelText: 'Search Filter',
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: convexHullImages.length,
                  itemBuilder: (context, index) {
                    String? name = convexHullImages[index].baseName(convexHullConfig);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            const SizedBox(height: 324.0),
                            _ImageSetWidget(
                              key: name != null ? Key(name) : UniqueKey(),
                              imageSet: convexHullImages[index],
                              convexHullConfig: convexHullConfig,
                              width: width,
                            ),
                          ],
                        ),
                        index < convexHullImages.length - 1 ? const Divider(color: Colors.white) : Container(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _ImageSetWidget extends ConsumerStatefulWidget {
  final ConvexHullImageSet imageSet;
  final ConvexHullConfigModel convexHullConfig;
  final double width;

  const _ImageSetWidget({
    required this.imageSet,
    required this.convexHullConfig,
    required this.width,
    super.key,
  });

  @override
  ConsumerState createState() => __ImageSetWidgetState();
}

class __ImageSetWidgetState extends ConsumerState<_ImageSetWidget> {
  static const cardSize = 150.0;
  bool mouseHover = false;

  @override
  Widget build(BuildContext context) {
    final config = widget.convexHullConfig.searchPatternProteinConfig;
    final searchPatterns = [...config.keys, widget.convexHullConfig.overlaySearchPattern];
    final proteinNames = [...config.values, 'Overlay'];
    List<Color> proteinColors = searchPatterns.map((name) {
      final colorConfig = widget.convexHullConfig.searchPatternOverlayColorConfig;
      final validation = widget.convexHullConfig.searchPatternOverlayConfig;
      if (validation[name] ?? false) {
        return Color(colorConfig[name] ?? 0);
      } else {
        return Colors.white;
      }
    }).toList();
    Map<int, TableColumnWidth> columnWidths = {0: const FixedColumnWidth(40)};
    for (int i = 1; i <= proteinNames.length; i++) {
      columnWidths[i] = const IntrinsicColumnWidth();
    }

    final asyncValue = ref.watch(convexHullDataProvider);

    return asyncValue.when(
      data: (data) {
        final images = widget.imageSet.images ?? [];
        final simplexIndex = images.indexWhere((image) => image.name.endsWith(convexHullTag));
        final infiltrationIndex = images.indexWhere((image) => image.name.endsWith(infiltrationTag));
        AbstractImage? simplex;
        AbstractImage? infiltration;
        if (simplexIndex != -1) {
          simplex = images[simplexIndex];
        }
        if (infiltrationIndex != -1) {
          infiltration = images[infiltrationIndex];
        }
        Map<String, dynamic> imageData = Map<String, dynamic>.from(data[widget.imageSet.baseName(widget.convexHullConfig)] ?? {});

        ConvexHullResults? results = ((simplex ?? infiltration) == null)
            ? null
            : ConvexHullResults(
                simplex: simplex,
                infiltration: infiltration,
                data: imageData,
              );

        return SizedBox(
          width: widget.width,
          child: ScrollConfiguration(
            behavior: DraggableScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: columnWidths,
                children: [
                  TableRow(
                    children: [
                      const SizedBox(width: 8.0),
                      ...List<Widget>.generate(
                        proteinNames.length,
                        (index) => Text(
                          proteinNames[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: proteinColors[index],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() => mouseHover = true);
                        },
                        onExit: (_) {
                          setState(() => mouseHover = false);
                        },
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditImageSetDialog(imageSet: widget.imageSet),
                            );
                          },
                          child: SizedBox(
                            height: cardSize,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                widget.imageSet.baseName(widget.convexHullConfig) ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...List<Widget>.generate(
                        searchPatterns.length,
                        (i) {
                          final index =
                              images.indexWhere((image) => image.name.contains(searchPatterns[i]) && !image.name.contains('bg_correct'));
                          if (index >= 0) {
                            return SizedBox(
                              height: cardSize,
                              width: cardSize,
                              child: ImageThumbnailCard(
                                key: Key(images[index].hashCode.toString()),
                                image: images[index],
                                callback: () {
                                  ref.read(appDataProvider.notifier).selectImage(image: images[index]);
                                },
                              ),
                            );
                          } else {
                            return const SizedBox(
                              height: cardSize,
                              width: cardSize,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const SizedBox(
                        height: cardSize,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Results',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ...List<Widget>.generate(
                        searchPatterns.length,
                        (i) {
                          final index = images.indexWhere((image) => image.name.contains(searchPatterns[i]) && image.name.contains(bgTag));
                          if (index >= 0) {
                            return SizedBox(
                              height: cardSize,
                              width: cardSize,
                              child: ImageThumbnailCard(
                                key: Key(images[index].hashCode.toString()),
                                image: images[index],
                                callback: () {
                                  ref.read(appDataProvider.notifier).selectImage(image: images[index]);
                                },
                              ),
                            );
                          } else {
                            if (i == searchPatterns.length - 1 && results != null) {
                              return SizedBox(
                                height: cardSize,
                                width: cardSize,
                                child: ConvexHullCard(results: results),
                              );
                            }
                            return const SizedBox(
                              height: cardSize,
                              width: cardSize,
                            );
                          }
                        },
                      ),
                    ],
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
