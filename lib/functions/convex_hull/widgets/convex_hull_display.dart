import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/lib/fife_image_helpers.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ConvexHullDisplay extends ConsumerStatefulWidget {
  const ConvexHullDisplay({super.key});

  @override
  ConsumerState<ConvexHullDisplay> createState() => _ConvexHullControlsState();
}

class _ConvexHullControlsState extends ConsumerState<ConvexHullDisplay> {
  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);
    final appData = ref.watch(appDataProvider);

    if (convexHullConfig.leftMenuEnum == LeftMenuEnum.functionImageSelection && appData.selectedImage != null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _BackgroundSelect(),
      );
    } else if (appData.activeResults != null) {
      return _ConvexHullResultsDisplay(
        config: convexHullConfig,
        appData: appData,
      );
    } else {
      return Container();
    }
  }
}

class _ConvexHullResultsDisplay extends ConsumerWidget {
  final ConvexHullConfigModel config;
  final AppDataStore appData;

  const _ConvexHullResultsDisplay({
    required this.config,
    required this.appData,
  });

  @override
  Widget build(BuildContext context, ref) {
    final asyncData = ref.watch(convexHullDataProvider);
    final results = appData.activeResults ?? const ConvexHullResults();

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
                            child: Image.file(
                              key: UniqueKey(),
                              File(results.simplex!.imagePath),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.file(
                      key: UniqueKey(),
                      File(results.simplex!.imagePath),
                    ),
                  ),
                ),
              ),
            ),
            results.infiltration != null
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
                                  child: Image.file(
                                    key: UniqueKey(),
                                    File(results.infiltration!.imagePath),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.file(
                            key: UniqueKey(),
                            File(results.infiltration!.imagePath),
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
                'on the right shows infiltration in the colors selected in and around the convex hull. The color '
                'key is displayed in the table below.',
                style: TextStyle(fontSize: 18.0),
              )
            : Container(),
        asyncData.when(
          data: (data) {
            final areaData = data[results.simplex?.baseName];
            if (areaData == null) {
              return Container();
            }
            final totalArea = areaData['total_image_area'];
            final totalIsletArea = areaData['total_islet_area'];
            final proteins = areaData['proteins'];
            final units = config.units;

            if (totalIsletArea == null || totalIsletArea == null || proteins == null) {
              return Container();
            }

            final formatter = NumberFormat("###,###.0#", "en_US");

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
                          text: 'Total Protein Outside Islet',
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
                        _TableEntry(
                          text: '% Area of Islet with Protein',
                          bold: true,
                        ),
                      ],
                    ),
                    ...proteins.entries.map((entry) {
                      final color = entry.value['validation_color'] != null ? Color(entry.value['validation_color']) : null;
                      return TableRow(children: [
                        _TableEntry(
                          text: entry.key,
                          color: color,
                          bold: true,
                        ),
                        _TableEntry(
                          text: formatter.format(entry.value['total_area'] ?? 0).toString(),
                          units: units,
                          superscript: '2',
                        ),
                        _TableEntry(
                          text: formatter.format(entry.value['outside_islet_area'] ?? 0).toString(),
                          units: units,
                          superscript: '2',
                        ),
                        _TableEntry(
                          text: formatter.format(entry.value['islet_area'] ?? 0).toString(),
                          units: units,
                          superscript: '2',
                        ),
                        _TableEntry(
                          text: formatter.format(entry.value['percent_islet_area'] ?? 0).toString(),
                          units: '%',
                        ),
                        _TableEntry(
                          text: formatter.format(entry.value['percent_of_islet_with_protein'] ?? 0).toString(),
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
                      text: 'Total Image Area: ${formatter.format(totalArea).toString()}',
                      units: units,
                      superscript: '2',
                    ),
                    _TableEntry(
                      text: 'Total Islet Area: ${formatter.format(totalIsletArea).toString()}',
                      units: units,
                      superscript: '2',
                    ),
                    Expanded(
                      child: Container(),
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
  final Color? color;
  final bool bold;

  const _TableEntry({
    required this.text,
    this.units,
    this.superscript,
    this.color,
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
                color: color ?? Colors.white,
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

class _BackgroundSelect extends ConsumerStatefulWidget {
  const _BackgroundSelect({super.key});

  @override
  ConsumerState createState() => __BackgroundSelectState();
}

class __BackgroundSelectState extends ConsumerState<_BackgroundSelect> with FifeImageHelpers {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.requestFocus();
    super.initState();
  }

  Future<void> performBackgroundCorrection(BuildContext context) async {
    try {
      ref.read(appDataProvider.notifier).setLoadingTrue();
      await ref.read(convexHullImageSetsProvider.notifier).backgroundSelect();
      if (!context.mounted) return;
    } on DioException catch (err, stack) {
      fifeImageSnackBar(
        context: context,
        message: err.response?.data.toString() ?? 'An error has occurred',
        dioErr: err,
        stack: stack,
      );
    } catch (err, stack) {
      fifeImageSnackBar(
        context: context,
        message: err.toString(),
        err: err,
        stack: stack,
      );
    } finally {
      ref.read(appDataProvider.notifier).setLoadingFalse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);
    final appData = ref.watch(appDataProvider);
    final image = appData.selectedImage;
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
                  onPressed: () async {
                    if (image != null) {
                      await ref.read(imagesProvider.notifier).updateSelection(image: image, selection: null);
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
                      if (!context.mounted) return;
                    } on DioException catch (err, stack) {
                      fifeImageSnackBar(
                        context: context,
                        message: err.response?.data.toString() ?? 'An error has occurred',
                        dioErr: err,
                        stack: stack,
                      );
                    } catch (err, stack) {
                      fifeImageSnackBar(
                        context: context,
                        message: err.toString(),
                        err: err,
                        stack: stack,
                      );
                    } finally {
                      ref.read(appDataProvider.notifier).setLoadingFalse();
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
      return KeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKeyEvent: (event) async {
          final key = event.logicalKey.keyLabel;
          if (key == 'Numpad Enter' || key == 'Enter') {
            await performBackgroundCorrection(context);
          }
        },
        child: Column(
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
                    onPressed: () async {
                      if (image != null) {
                        await ref.read(imagesProvider.notifier).updateSelection(image: image, selection: null);
                      }
                    },
                    child: const Text('Clear Selection'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => performBackgroundCorrection(context),
                    child: const Text('Perform Background Correction'),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return const Text('error');
    }
  }
}
