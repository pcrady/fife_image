import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_image_provider.g.dart';

@riverpod
class ConvexHullImage extends _$ConvexHullImage {
  final _dio = Dio();

  @override
  List<ImageSet> build() {
    final asyncValue = ref.watch(imagesProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullState = settings.convexHullState;

    return asyncValue.when(
      data: (images) {
        List<ImageSet> sortedImages = [];
        for (AbstractImage image in images) {
          final baseNames = sortedImages.map((imageSet) => imageSet.baseName).toList();

          ImageSet imageSet = sortedImages.firstWhere(
            (element) => element.baseName == image.baseName,
            orElse: () => ImageSet(),
          );

          _addToChannel(
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

  _addToChannel({
    required ImageSet imageSet,
    required AbstractImage image,
    required String channel1Filter,
    required String channel2Filter,
    required String channel3Filter,
    required String channel4Filter,
    required String overlayFilter,
  }) {
    imageSet.baseName ??= image.baseName;
    if (image.name.contains(channel1Filter)) {
      imageSet.channel1 = image;
    } else if (image.name.contains(channel2Filter)) {
      imageSet.channel2 = image;
    } else if (image.name.contains(channel3Filter)) {
      imageSet.channel3 = image;
    } else if (image.name.contains(channel4Filter)) {
      imageSet.channel4 = image;
    } else if (image.name.contains(overlayFilter)) {
      imageSet.overlay = image;
    }
  }

  Future<Response?> backgroundSelect() async {
    final appData = ref.read(appDataProvider);
    final image = appData.selectedImage;
    if (image == null) return null;
    if (image.filePath == null) return null;
    if (image.selectionRegionPython.isEmpty) return null;

    final response = await _dio.post(
      '${server}background_correction',
      data: {
        'image_path': image.filePath!,
        'selected_region': image.selectionRegionPython,
      },
    );
    logger.i(response);
    ref.invalidateSelf();
    return response;
  }
}
