import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_image_provider.g.dart';

@riverpod
class ConvexHullImageProvider extends _$ConvexHullImageProvider {
  @override
  Map<String, List<AbstractImage>> build() {
    final asyncValue = ref.watch(imagesProvider);
    final settings = ref.watch(appDataProvider);
    final convexHullState = settings.convexHullState;

    return asyncValue.when(
      data: (data) {
        return {};
      },
      error: (err, stack) {
        logger.e(err, stackTrace: stack);
        return {};
      },
      loading: () => {},
    );
  }
}
