import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_data_model.freezed.dart';
part 'convex_hull_data_model.g.dart';

@freezed
class ConvexHullDataModel with _$ConvexHullDataModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullDataModel({
  double? totalImageArea,
  double? totalIsletArea,
  double? totalCd4Area,
  double? totalCd8Area,
  double? totalInsulinArea,
  double? totalGlucagonArea,
  double? totalPdl1Area,

  double? isletCd4Area,
  double? isletCd8Area,
  double? isletInsulinArea,
  double? isletGlucagonArea,
  double? isletPdl1Area,

  double? cd4PercentIsletArea,
  double? cd8PercentIsletArea,
  double? insulinPercentIsletArea,
  double? glucagonPercentIsletArea,
  double? pdl1PercentIsletArea
}) = _ConvexHullDataModel;

  factory ConvexHullDataModel.fromJson(Map<String, dynamic> json) => _$ConvexHullDataModelFromJson(json);
}