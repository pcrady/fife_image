import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
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
    final asyncValue = ref.watch(imagesProvider);
    final convexHullConfig = ref.watch(convexHullConfigProvider);

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
            channel0Filter: convexHullConfig.channel0SearchPattern,
            channel1Filter: convexHullConfig.channel1SearchPattern,
            channel2Filter: convexHullConfig.channel2SearchPattern,
            channel3Filter: convexHullConfig.channel3SearchPattern,
            channel4Filter: convexHullConfig.channel4SearchPattern,
            overlayFilter: convexHullConfig.overlaySearchPattern,
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
    required String channel0Filter,
    required String channel1Filter,
    required String channel2Filter,
    required String channel3Filter,
    required String channel4Filter,
    required String overlayFilter,
  }) {
    ConvexHullImageSet returnSet = imageSet.copyWith(baseName: image.baseName);
    if (_isPrimaryImage(image, channel0Filter)) {
      returnSet = returnSet.copyWith(channel0: image);
    } else if (_isPrimaryImage(image, channel1Filter)) {
      returnSet = returnSet.copyWith(channel1: image);
    } else if (_isPrimaryImage(image, channel2Filter)) {
      returnSet = returnSet.copyWith(channel2: image);
    } else if (_isPrimaryImage(image, channel3Filter)) {
      returnSet = returnSet.copyWith(channel3: image);
    } else if (_isPrimaryImage(image, channel4Filter)) {
      returnSet = returnSet.copyWith(channel4: image);
    } else if (_isPrimaryImage(image, overlayFilter)) {
      returnSet = returnSet.copyWith(overlay: image);
    } else if (_isCorrectedImage(image, channel0Filter)) {
      returnSet = returnSet.copyWith(channel0BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel1Filter)) {
      returnSet = returnSet.copyWith(channel1BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel2Filter)) {
      returnSet = returnSet.copyWith(channel2BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel3Filter)) {
      returnSet = returnSet.copyWith(channel3BackgroundCorrect: image);
    } else if (_isCorrectedImage(image, channel4Filter)) {
      returnSet = returnSet.copyWith(channel4BackgroundCorrect: image);
    }

    if (image.name.contains('inflammation')) {
      final results = returnSet.results;
      final newResults = results.copyWith(inflammation: image);
      returnSet = returnSet.copyWith(results: newResults);
    }

    if (image.name.contains('simplex')) {
      final results = returnSet.results;
      final newResults = results.copyWith(simplex: image);
      returnSet = returnSet.copyWith(results: newResults);
    }

    return returnSet;
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

  Future<void> performCalculation() async {
    final appData = ref.read(appDataProvider);
    final selectedImage = appData.selectedImage;
    final imageSet = state.singleWhere(
      (imageSet) => imageSet.overlay == selectedImage,
      orElse: () => ConvexHullImageSet(),
    );
    if (selectedImage == null) return;
    if (imageSet.overlay != selectedImage) return;
    if (imageSet.channel0BackgroundCorrect == null) return;
    if (imageSet.channel1BackgroundCorrect == null) return;
    if (imageSet.channel2BackgroundCorrect == null) return;
    if (imageSet.channel3BackgroundCorrect == null) return;
    if (imageSet.channel4BackgroundCorrect == null) return;

    final config = ref.read(convexHullConfigProvider);
    final channel0Name = config.channel0ProteinName;
    final channel1Name = config.channel1ProteinName;
    final channel2Name = config.channel2ProteinName;
    final channel3Name = config.channel3ProteinName;
    final channel4Name = config.channel4ProteinName;
    final imageWidth = config.imageWidth;
    final imageHeight = config.imageHeight;

    final response = await _dio.post(
      '${server}convex_hull_calculation',
      data: {
        'base_image': imageSet.overlay?.baseName ?? '',
        channel0Name: imageSet.channel0BackgroundCorrect!.toJson(),
        channel1Name: imageSet.channel1BackgroundCorrect!.toJson(),
        channel2Name: imageSet.channel2BackgroundCorrect!.toJson(),
        channel3Name: imageSet.channel3BackgroundCorrect!.toJson(),
        channel4Name: imageSet.channel4BackgroundCorrect!.toJson(),
        'Overlay': selectedImage.toJson(),
        'width': imageWidth,
        'height': imageHeight,
      },
    );

    ref.invalidate(imagesProvider);
  }
}
