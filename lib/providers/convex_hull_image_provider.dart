import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/convex_hull_image_set.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_image_provider.g.dart';

@riverpod
class ConvexHullImageSets extends _$ConvexHullImageSets {
  final _dio = Dio();

  // TODO redo this it cant be performant maybe build a json structure
  @override
  List<ConvexHullImageSet> build() {
    final asyncValue = ref.watch(imagesProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullState = settings.convexHullState;

    return asyncValue.when(
      data: (images) {
        List<ConvexHullImageSet> sortedImages = [];
        for (AbstractImage image in images) {
          final oldImageSet = sortedImages.firstWhere(
            (element) => element.baseName == image.baseName,
            orElse: () => ConvexHullImageSet(),
          );

          final newImageSet = _addToImageSet(
            imageSet: oldImageSet,
            image: image,
            channel1Filter: convexHullState.channel1SearchPattern,
            channel2Filter: convexHullState.channel2SearchPattern,
            channel3Filter: convexHullState.channel3SearchPattern,
            channel4Filter: convexHullState.channel4SearchPattern,
            overlayFilter: convexHullState.overlaySearchPattern,
          );
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

  List<AbstractImage> unmodifiedImages() {
    List<AbstractImage> images = [];
    for (ConvexHullImageSet imageSet in state) {
      images = [...images, ...imageSet.unmodifiedImages];
    }
    return images;
  }

  List<AbstractImage> backgroundCorrectionImages() {
    List<AbstractImage> images = [];
    for (ConvexHullImageSet imageSet in state) {
      images = [...images, ...imageSet.backgroundCorrectedImages];
    }
    return images;
  }

  _isPrimaryImage(AbstractImage image, String filter) {
    return image.name.contains(filter) && !image.name.contains(bgTag);
  }

  _isCorrectedImage(AbstractImage image, String filter) {
    return image.name.contains(filter) && image.name.contains(bgTag);
  }

  ConvexHullImageSet _addToImageSet({
    required ConvexHullImageSet imageSet,
    required AbstractImage image,
    required String channel1Filter,
    required String channel2Filter,
    required String channel3Filter,
    required String channel4Filter,
    required String overlayFilter,
  }) {
    ConvexHullImageSet returnSet = imageSet.copyWith(baseName: image.baseName);
    if (_isPrimaryImage(image, channel1Filter)) {
      returnSet = returnSet.copyWith(channel1: image);
    } else if (_isPrimaryImage(image, channel2Filter)) {
      returnSet = returnSet.copyWith(channel2: image);
    } else if (_isPrimaryImage(image, channel3Filter)) {
      returnSet = returnSet.copyWith(channel3: image);
    } else if (_isPrimaryImage(image, channel4Filter)) {
      returnSet = returnSet.copyWith(channel4: image);
    } else if (_isPrimaryImage(image, overlayFilter)) {
      returnSet = returnSet.copyWith(overlay: image);
    } else if (_isCorrectedImage(image, channel1Filter)) {
      returnSet = returnSet.copyWith(channel1BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel2Filter)) {
      returnSet = returnSet.copyWith(channel2BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel3Filter)) {
      returnSet = returnSet.copyWith(channel3BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel4Filter)) {
      returnSet = returnSet.copyWith(channel4BackgroundCorrect: image);
    }

    return returnSet;
  }

  Future<void> backgroundSelect() async {
    final appData = ref.read(appDataProvider);
    final image = appData.selectedImage;
    if (image == null) return;
    logger.i(image.toJson());

    await _dio.post(
      '${server}background_correction',
      data: image.toJson(),
    );
    ref.invalidate(imagesProvider);
  }
}
