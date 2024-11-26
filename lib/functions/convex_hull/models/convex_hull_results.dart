import 'package:fife_image/models/abstract_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'convex_hull_results.freezed.dart';
part 'convex_hull_results.g.dart';

@freezed
class ConvexHullResults with _$ConvexHullResults {
  const ConvexHullResults._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullResults({
    AbstractImage? inflammation,
    AbstractImage? simplex,
    AbstractImage? infiltration,
    Map<String, dynamic>? data,
  }) = _ConvexHullResults;


  factory ConvexHullResults.fromJson(Map<String, dynamic> json) => _$ConvexHullResultsFromJson(json);
}
