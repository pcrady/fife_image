import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'convex_hull_image_set.freezed.dart';
part 'convex_hull_image_set.g.dart';

@freezed
class ConvexHullImageSet with _$ConvexHullImageSet {
  const ConvexHullImageSet._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  factory ConvexHullImageSet({
    List<AbstractImage>? images,
    @Default(ConvexHullResults()) ConvexHullResults results,
  }) = _ConvexHullImageSet;

  List<String> get imageNames {
    return images?.map((image) => image.name).toList() ?? [];
  }

  String? get baseName {
    if (images == null) return null;
    assert(images!.map((image) => image.baseName).toSet().length == 1);
    return images?.first.baseName;
  }

  bool bgCorrectComplete(ConvexHullConfigModel config) {
    List<String> searchPatterns = config.searchPatternProteinConfig.keys.toList();
    for (final pattern in searchPatterns) {
      final subset = (images ?? []).where((image) => image.name.contains(pattern)).toList();
      if (!subset.any((image) => image.isBackgroundCorrected)) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toJsonForCalc({
    required ConvexHullConfigModel hullConfig,
    required AbstractImage overlayImage,
  }) {
    final searchPatternProteinConfig = hullConfig.searchPatternProteinConfig;
    Map<String, dynamic> imageData = {};

    searchPatternProteinConfig.forEach((searchPattern, protein) {
      for (final image in images ?? []) {
        if (image.name.contains(searchPattern) && image.isBackgroundCorrected) {
          imageData[protein] = image.toJson();
          imageData[protein]['validation'] = hullConfig.searchPatternOverlayConfig[searchPattern];
          imageData[protein]['validation_color'] = hullConfig.searchPatternOverlayColorConfig[searchPattern];
        }
      }
    });
    imageData['overlay'] = overlayImage.toJson();
    imageData['overlay']['validation'] = false;
    imageData['overlay']['validation_color'] = 0;
    return imageData;
  }

  factory ConvexHullImageSet.fromJson(Map<String, dynamic> json) => _$ConvexHullImageSetFromJson(json);
}
