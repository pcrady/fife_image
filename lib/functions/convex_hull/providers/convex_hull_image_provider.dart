import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_image_provider.g.dart';

@riverpod
class ConvexHullImageSets extends _$ConvexHullImageSets {
  final _dio = Dio();

  @override
  List<ConvexHullImageSet> build() {
    final imagesAsyncValue = ref.watch(imagesProvider);
    final convexHullConfigModel = ref.watch(convexHullConfigProvider);

    return imagesAsyncValue.when(
      data: (images) {
        final groupedImages = groupBy<AbstractImage, String>(images, (image) => image.baseName(convexHullConfigModel));
        return groupedImages.values.map((imageList) => ConvexHullImageSet(images: imageList)).toList();
      },
      error: (err, stack) {
        logger.e(err, stackTrace: stack);
        return [];
      },
      loading: () => [],
    );
  }

  Future<void> backgroundSelect() async {
    final appData = ref.read(appDataProvider);
    final image = appData.selectedImage;
    if (image == null) return;

    final selectionArea = image.relativeSelectionCoordinates;
    if (selectionArea == null || selectionArea.isEmpty) {
      throw 'You must select an area';
    }

    await _dio.post(
      '${server}background_correction',
      data: image.toJson(),
    );
    ref.invalidate(imagesProvider);
  }

  Future<void> performCalculation() async {
    final hullConfig = ref.read(convexHullConfigProvider);
    final appData = ref.read(appDataProvider);
    String? activeImageSetBaseName = appData.selectedImage?.baseName(hullConfig);
    final overlayImage = ref.read(appDataProvider).selectedImage;
    final imageSetIndex = state.indexWhere((set) => set.baseName(hullConfig) == activeImageSetBaseName);

    if (overlayImage == null || imageSetIndex == -1) {
      throw 'Something has gone wrong';
    }

    final selectionArea = overlayImage.relativeSelectionCoordinates;
    if (selectionArea == null || selectionArea.isEmpty) {
      throw 'You must select the islet area';
    }

    final activeImageSet = state[imageSetIndex];
    final imageData = activeImageSet.toJsonForCalc(hullConfig: hullConfig, overlayImage: overlayImage);
    final proteinNames = imageData.keys;

    if (!activeImageSet.bgCorrectComplete(hullConfig)) {
      throw 'You must perform background correction on all images in the set';
    }

    if (!proteinNames.contains(insulin) || !proteinNames.contains(glucagon)) {
      throw 'You must include Insulin and Glucagon';
    }

    logger.i(hullConfig.colocalizationConfig);

    final data = {
      'base_image_name': activeImageSetBaseName,
      'pixel_size': hullConfig.pixelSize,
      'cell_size': hullConfig.cellSize,
      'colocalization_config': hullConfig.colocalizationConfig,
      'images': imageData,
    };

    await _dio.post(
      '${server}convex_hull_calculation',
      data: data,
    );
    ref.invalidate(imagesProvider);
    ref.invalidate(convexHullDataProvider);
  }
}
