import 'package:fife_image/models/abstract_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'convex_hull_image_set.freezed.dart';
part 'convex_hull_image_set.g.dart';

@freezed
class ConvexHullImageSet with _$ConvexHullImageSet {
  const ConvexHullImageSet._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  factory ConvexHullImageSet({
    String? baseName,
    AbstractImage? channel1,
    AbstractImage? channel1BackgroundCorrect,
    AbstractImage? channel2,
    AbstractImage? channel2BackgroundCorrect,
    AbstractImage? channel3,
    AbstractImage? channel3BackgroundCorrect,
    AbstractImage? channel4,
    AbstractImage? channel4BackgroundCorrect,
    AbstractImage? overlay,
  }) = _ConvexHullImageSet;

  factory ConvexHullImageSet.fromJson(Map<String, dynamic> json) => _$ConvexHullImageSetFromJson(json);

  List<AbstractImage> get backgroundCorrectedImages {
    List<AbstractImage> values = [];
    if (channel1BackgroundCorrect != null) {
      values.add(channel1BackgroundCorrect!);
    }
    if (channel2BackgroundCorrect != null) {
      values.add(channel2BackgroundCorrect!);
    }
    if (channel3BackgroundCorrect != null) {
      values.add(channel3BackgroundCorrect!);
    }
    if (channel4BackgroundCorrect != null) {
      values.add(channel4BackgroundCorrect!);
    }
    return values;
  }

  List<AbstractImage> get unmodifiedImages {
    List<AbstractImage> values = [];
    if (channel1 != null) {
      values.add(channel1!);
    }
    if (channel2 != null) {
      values.add(channel2!);
    }
    if (channel3 != null) {
      values.add(channel3!);
    }
    if (channel4 != null) {
      values.add(channel4!);
    }
    return values;
  }
}