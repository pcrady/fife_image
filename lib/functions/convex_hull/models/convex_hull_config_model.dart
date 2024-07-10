import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config_model.freezed.dart';
part 'convex_hull_config_model.g.dart';

@freezed
class ConvexHullConfigModel with _$ConvexHullConfigModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullConfigModel({
    String? activeImageSetBaseName,
    AbstractImage? activeImage,
    ConvexHullResults? activeResults,
    @Default(LeftMenuEnum.functionSettings) LeftMenuEnum leftMenuEnum,
    @Default('ch00') String channel0SearchPattern,
    @Default('ch01') String channel1SearchPattern,
    @Default('ch02') String channel2SearchPattern,
    @Default('ch03') String channel3SearchPattern,
    @Default('ch04') String channel4SearchPattern,
    @Default('overlay') String overlaySearchPattern,
    @Default(cd4) String channel0ProteinName,
    @Default(glucagon) String channel1ProteinName,
    @Default(insulin) String channel2ProteinName,
    @Default(cd8) String channel3ProteinName,
    @Default(pdl1) String channel4ProteinName,
    @Default(10.0) double imageWidth,
    @Default(10.0) imageHeight
  }) = _ConvexHullConfigModel;

  factory ConvexHullConfigModel.fromJson(Map<String, dynamic> json) => _$ConvexHullConfigModelFromJson(json);
}
