import 'package:fife_image/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config.freezed.dart';
part 'convex_hull_config.g.dart';

@freezed
class ConvexHullConfig with _$ConvexHullConfig {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullConfig({
    String? activeImageSetBaseName,
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
    @Default(dapi) String channel4ProteinName,
  }) = _ConvexHullConfig;

  factory ConvexHullConfig.fromJson(Map<String, dynamic> json) => _$ConvexHullConfigFromJson(json);
}
