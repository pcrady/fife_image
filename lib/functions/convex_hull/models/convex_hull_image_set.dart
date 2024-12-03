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

  factory ConvexHullImageSet.fromJson(Map<String, dynamic> json) => _$ConvexHullImageSetFromJson(json);
}
