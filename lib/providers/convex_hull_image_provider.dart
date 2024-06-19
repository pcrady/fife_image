import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_image_provider.g.dart';

@riverpod
class ConvexHullImageSets extends _$ConvexHullImageSets {
  final _dio = Dio();

  @override
  List<ConvexHullImageSet> build() {
    final asyncValue = ref.watch(imagesProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullState = settings.convexHullState;

    return asyncValue.when(
      data: (images) {
        List<ConvexHullImageSet> sortedImages = [];
        for (AbstractImage image in images) {
          final baseNames = sortedImages.map((imageSet) => imageSet.baseName).toList();

          ConvexHullImageSet imageSet = sortedImages.firstWhere(
            (element) => element.baseName == image.baseName,
            orElse: () => ConvexHullImageSet(),
          );

          _addToImageSet(
            imageSet: imageSet,
            image: image,
            channel1Filter: convexHullState.channel1SearchPattern,
            channel2Filter: convexHullState.channel2SearchPattern,
            channel3Filter: convexHullState.channel3SearchPattern,
            channel4Filter: convexHullState.channel4SearchPattern,
            overlayFilter: convexHullState.overlaySearchPattern,
          );

          if (!baseNames.contains(imageSet.baseName)) {
            sortedImages.add(imageSet);
          }
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

  _addToImageSet({
    required ConvexHullImageSet imageSet,
    required AbstractImage image,
    required String channel1Filter,
    required String channel2Filter,
    required String channel3Filter,
    required String channel4Filter,
    required String overlayFilter,
  }) {
    imageSet.baseName ??= image.baseName;

    if (_isPrimaryImage(image, channel1Filter)) {
      imageSet.channel1 = image;
    } else if (_isPrimaryImage(image, channel2Filter)) {
      imageSet.channel2 = image;
    } else if (_isPrimaryImage(image, channel3Filter)) {
      imageSet.channel3 = image;
    } else if (_isPrimaryImage(image, channel4Filter)) {
      imageSet.channel4 = image;
    } else if (_isPrimaryImage(image, overlayFilter)) {
      imageSet.overlay = image;
    } else if (_isCorrectedImage(image, channel1Filter)) {
      imageSet.channel1BackgroundCorrect = image;
    } else if (_isCorrectedImage(image, channel2Filter)) {
      imageSet.channel2BackgroundCorrect = image;
    } else if (_isCorrectedImage(image, channel3Filter)) {
      imageSet.channel3BackgroundCorrect = image;
    } else if (_isCorrectedImage(image, channel4Filter)) {
      imageSet.channel4BackgroundCorrect = image;
    }
  }

  Future<void> backgroundSelect() async {
    final appData = ref.read(appDataProvider);
    final image = appData.selectedImage;
    if (image == null) return ;
    if (image.filePath == null) return ;
    if (image.selectionRegionPython.isEmpty) return ;

    await _dio.post(
      '${server}background_correction',
      data: {
        'image_path': image.filePath!,
        'selected_region': image.selectionRegionPython,
      },
    );
    ref.invalidate(imagesProvider);
  }
}
