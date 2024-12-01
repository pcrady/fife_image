
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
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

    return imagesAsyncValue.when(
      data: (images) {
        List<ConvexHullImageSet> sortedImages = [];
        for (AbstractImage image in images) {
          final oldImageSet = sortedImages.firstWhere(
            (element) => element.baseName == image.baseName,
            orElse: () => ConvexHullImageSet(baseName: image.baseName),
          );
          List<AbstractImage> imageList = List.from(oldImageSet.images ?? [])..add(image);
          final newImageSet = oldImageSet.copyWith(images: imageList);
          sortedImages.remove(oldImageSet);
          sortedImages.add(newImageSet);
        }

        return sortedImages;
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

    await _dio.post(
      '${server}background_correction',
      data: image.toJson(),
    );
    ref.invalidate(imagesProvider);
  }

  Map<String, dynamic> _getImageLabel({
    required ConvexHullConfigModel hullData,
    required ConvexHullImageSet imageSet,
  }) {
    final images = imageSet.images ?? [];
    final searchPatternProteinConfig = hullData.searchPatternProteinConfig;
    Map<String, dynamic> labeledImages = {};

    searchPatternProteinConfig.forEach((searchPattern, protein) {
      for (final image in images) {
        if (image.name.contains(searchPattern) && image.isBackgroundCorrected) {
          labeledImages[protein] = image.toJson();
          labeledImages[protein]['validation'] = hullData.searchPatternOverlayConfig[searchPattern];
          labeledImages[protein]['validation_color'] = hullData.searchPatternOverlayColorConfig[searchPattern];
        }
      }
    });
    return labeledImages;
  }

  Future<void> performCalculation() async {
    final hullData = ref.read(convexHullConfigProvider);
    final appData = ref.read(appDataProvider);
    final activeImageSetBaseName = appData.selectedImage?.baseName;
    final activeImage = ref.read(appDataProvider).selectedImage;
    if (activeImage == null) return;
    final imageSetIndex = state.indexWhere((set) => set.baseName == activeImageSetBaseName);
    if (imageSetIndex == -1) return;
    final activeImageSet = state[imageSetIndex];

    var imageData = _getImageLabel(
      hullData: hullData,
      imageSet: activeImageSet,
    );
    imageData['overlay'] = activeImage.toJson();
    imageData['overlay']['validation'] = false;
    imageData['overlay']['validation_color'] = 0;
    final proteinNames = imageData.keys;

    if (proteinNames.length != hullData.searchPatternProteinConfig.keys.length + 1) {
      throw 'You must perform background correction on all images in the set';
    }

    if (!proteinNames.contains(insulin) || !proteinNames.contains(glucagon)) {
      throw 'You must include Insulin and Glucagon';
    }

    final data = {
      'base_image_name': activeImageSetBaseName,
      'width': hullData.imageWidth,
      'height': hullData.imageHeight,
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
