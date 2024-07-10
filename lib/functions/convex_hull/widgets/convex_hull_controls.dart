import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
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
      return _ConvexHullResultsDisplay(
        config: convexHullConfig,
      );
    } else {
      return Container();
    }
  }
}

class _ConvexHullResultsDisplay extends ConsumerWidget {
  final ConvexHullConfigModel config;

  const _ConvexHullResultsDisplay({
    required this.config,
  });

  @override
  Widget build(BuildContext context, ref) {
    final asyncData = ref.watch(convexHullDataProvider);
    final results = config.activeResults ?? const ConvexHullResults();
    final imageSetBaseName = config.activeImageSetBaseName;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      //TODO popup modal
                    },
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
              ),
            ),
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      //TODO popup modal
                    },
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
              ),
            ),
          ],
        ),
        asyncData.when(
          data: (data) {
            final areaData = data[imageSetBaseName];
            final units = config.units;

            if (areaData == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imageSetBaseName ?? '',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('CD4 is displayed as blue and CD8 is deplayed as red.\nNote: For the calculations below small'
                    ' objects were not filtered out as they were for the convex hull calculation.'),
                Table(
                  border: TableBorder.all(
                    color: Colors.black, // Border color
                    width: 1.0, // Border width
                  ),
                  children: [
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total Image Area'),
                        _TableEntry(
                          text: areaData.totalImageArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total islet Area'),
                        _TableEntry(
                          text: areaData.totalIsletArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total CD4 Area'),
                        _TableEntry(
                          text: areaData.totalCd4Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total CD8 Area'),
                        _TableEntry(
                          text: areaData.totalCd8Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total Glucagon Area'),
                        _TableEntry(
                          text: areaData.totalGlucagonArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total Insulin Area'),
                        _TableEntry(
                          text: areaData.totalInsulinArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total PD-L1 Area'),
                        _TableEntry(
                          text: areaData.totalPdl1Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Total islet Area'),
                        _TableEntry(
                          text: areaData.totalIsletArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Islet CD4 Area'),
                        _TableEntry(
                          text: areaData.isletCd4Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Islet CD8 Area'),
                        _TableEntry(
                          text: areaData.isletCd8Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Islet Glucagon Area'),
                        _TableEntry(
                          text: areaData.isletGlucagonArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Islet Insulin Area'),
                        _TableEntry(
                          text: areaData.isletInsulinArea!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: 'Islet PD-L1 Area'),
                        _TableEntry(
                          text: areaData.isletPdl1Area!.toStringAsFixed(2),
                          units: units,
                          superscript: '2',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: '% of Islet CD4'),
                        _TableEntry(
                          text: (areaData.cd4PercentIsletArea! * 100).toStringAsFixed(2),
                          units: '%',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: '% of Islet CD8'),
                        _TableEntry(
                          text: (areaData.cd8PercentIsletArea! * 100).toStringAsFixed(2),
                          units: '%',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: '% of Islet Glucagon'),
                        _TableEntry(
                          text: (areaData.glucagonPercentIsletArea! * 100).toStringAsFixed(2),
                          units: '%',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: '% of Islet Insulin'),
                        _TableEntry(
                          text: (areaData.insulinPercentIsletArea! * 100).toStringAsFixed(2),
                          units: '%',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const _TableEntry(text: '% of Islet PD-L1'),
                        _TableEntry(
                          text: (areaData.pdl1PercentIsletArea! * 100).toStringAsFixed(2),
                          units: '%',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          error: (err, stack) {
            logger.e(err, stackTrace: stack);
            return Text(err.toString());
          },
          loading: () {
            return Container();
          },
        ),
      ],
    );
  }
}

class _TableEntry extends StatelessWidget {
  final String text;
  final String? units;
  final String? superscript;

  const _TableEntry({
    required this.text,
    this.units,
    this.superscript,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: text),
            TextSpan(text: ' ${units ?? ''}'),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(0, -4),
                child: Text(
                  superscript ?? '',
                  textScaler: const TextScaler.linear(0.8),
                ),
              ),
            )
          ],
        ),
      ),
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
