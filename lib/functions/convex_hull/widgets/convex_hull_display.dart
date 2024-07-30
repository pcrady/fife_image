import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullDisplay extends ConsumerStatefulWidget {
  const ConvexHullDisplay({super.key});

  @override
  ConsumerState<ConvexHullDisplay> createState() => _ConvexHullControlsState();
}

class _ConvexHullControlsState extends ConsumerState<ConvexHullDisplay> {
  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);

    if (convexHullConfig.leftMenuEnum == LeftMenuEnum.functionImageSelection && convexHullConfig.activeImage != null) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                foregroundDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: CachedNetworkImage(
                              imageUrl: results.simplex!.url,
                              cacheKey: results.simplex!.md5Hash,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorListener: (error) {
                                logger.e(error);
                              },
                            ),
                          );
                        },
                      );
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
            results.inflammation != null
                ? Expanded(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: CachedNetworkImage(
                                    imageUrl: results.inflammation!.url,
                                    cacheKey: results.inflammation!.md5Hash,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorListener: (error) {
                                      logger.e(error);
                                    },
                                  ),
                                );
                              },
                            );
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
                  )
                : Container(),
          ],
        ),
        results.inflammation != null
            ? const Text(
                'The image on the left shows the convex hull superimposed on top of the overlay image. The image '
                'on the right shows CD4 (Blue) and CD8 (Red) in and around the convex hull.',
                style: TextStyle(fontSize: 18.0),
              )
            : Container(),
        asyncData.when(
          data: (data) {
            final areaData = data[imageSetBaseName];
            final totalArea = areaData['total_image_area'];
            final totalIsletArea = areaData['total_islet_area'];
            final proteins = areaData['proteins'];
            final units = config.units;

            if (areaData == null) {
              return Container();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Table(
                  border: TableBorder.all(color: Colors.white),
                  children: [
                    const TableRow(
                      children: [
                        _TableEntry(
                          text: 'Protein Name',
                          bold: true,
                        ),
                        _TableEntry(
                          text: 'Total Protein Area',
                          bold: true,
                        ),
                        _TableEntry(
                          text: 'Total Protein Area in Islet',
                          bold: true,
                        ),
                        _TableEntry(
                          text: '% Protein Inside Islet',
                          bold: true,
                        ),
                      ],
                    ),
                    ...proteins.entries.map((entry) {
                      return TableRow(children: [
                        _TableEntry(
                          text: entry.key,
                        ),
                        _TableEntry(
                          text: entry.value['total_area'].toStringAsFixed(3),
                          units: units,
                          superscript: '2',
                        ),
                        _TableEntry(
                          text: entry.value['islet_area'].toStringAsFixed(3),
                          units: units,
                          superscript: '2',
                        ),
                        _TableEntry(
                          text: entry.value['percent_islet_area'].toStringAsFixed(3),
                          units: '%',
                        ),
                      ]);
                    }),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    _TableEntry(
                      text: 'Total Image Area: ${totalArea.toStringAsFixed(3)}',
                      units: units,
                      superscript: '2',
                    ),
                    _TableEntry(
                      text: 'Total Islet Area: ${totalIsletArea.toStringAsFixed(3)}',
                      units: units,
                      superscript: '2',
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(convexHullDataProvider.notifier).downloadJSONData();
                      },
                      child: const Text('Download json'),
                    ),
                    /*const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(convexHullDataProvider.notifier).downloadCSVData();
                      },
                      child: const Text('Download csv'),
                    ),*/
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
  final bool bold;

  const _TableEntry({
    required this.text,
    this.units,
    this.superscript,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' ${units ?? ''}',
              style: const TextStyle(color: Colors.white),
            ),
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
    final image = convexHullConfig.activeImage;
    final name = image?.name ?? '';

    if (name.contains(bgTag)) {
      return Column(
        children: [
          image != null ? SelectedImage(image: image) : Container(),
        ],
      );
    } else if (name.contains(convexHullConfig.overlaySearchPattern)) {
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
                      ref.read(appDataProvider.notifier).setLoadingTrue();
                      await ref.read(convexHullImageSetsProvider.notifier).performCalculation();
                    } catch (err, stack) {
                      logger.e(err, stackTrace: stack);
                      final snackBar = SnackBar(
                        content: Text(err.toString()),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Perform Calculations'),
                ),
              )
            ],
          ),
        ],
      );
    } else if (!name.contains(bgTag)) {
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
                      ref.read(appDataProvider.notifier).setLoadingTrue();
                      await ref.read(convexHullImageSetsProvider.notifier).backgroundSelect();
                    } catch (err, stack) {
                      logger.e(err, stackTrace: stack);
                      final snackBar = SnackBar(
                        content: Text(err.toString()),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      return const Text('error');
    }
  }
}
