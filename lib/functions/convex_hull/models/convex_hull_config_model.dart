import 'package:fife_image/constants.dart';
import 'package:fife_image/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config_model.freezed.dart';
part 'convex_hull_config_model.g.dart';

@freezed
class ConvexHullConfigModel with _$ConvexHullConfigModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullConfigModel({
    @Default(LeftMenuEnum.functionSettings) LeftMenuEnum leftMenuEnum,
    @Default(overlay) String overlaySearchPattern,
    @Default({}) Map<String, String> searchPatternProteinConfig,
    @Default({}) Map<String, bool> searchPatternOverlayConfig,
    @Default({}) Map<String, int> searchPatternOverlayColorConfig,
    @Default(width) double pixelSize,
    @Default(lengthScale) String units,
    @Default(totalChannelNumber) int channelNumber,
  }) = _ConvexHullConfigModel;

  factory ConvexHullConfigModel.fromJson(Map<String, dynamic> json) => _$ConvexHullConfigModelFromJson(json);
}
