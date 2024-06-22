import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
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
    final appData = ref.watch(appDataProvider);
    final convexHullConfig = ref.watch(convexHullConfigProvider);


    if (convexHullConfig.leftMenuEnum == LeftMenuEnum.functionResults && appData.selectedImage != null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: _BackgroundSelect(),
      );
    } else {
      return Container();
    }
  }
}

class _BackgroundSelect extends ConsumerWidget {
  const _BackgroundSelect();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(appDataProvider);
    final correctedImages = ref.read(convexHullImageSetsProvider.notifier).backgroundCorrectionImages();
    final unmodifiedImages = ref.read(convexHullImageSetsProvider.notifier).unmodifiedImages();
    final image = appData.selectedImage;

    if (correctedImages.contains(image)) {
      return const Column(
        children: [
          SelectedImage(),
        ],
      );
    } else if (unmodifiedImages.contains(image)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SelectedImage(),
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
          const SelectedImage(),
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
