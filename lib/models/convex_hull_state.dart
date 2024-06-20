import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_state.freezed.dart';
part 'convex_hull_state.g.dart';

@freezed
class ConvexHullState with _$ConvexHullState {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullState({
    String? activeImageSetBaseName,
    @Default('ch00') String channel0SearchPattern,
    @Default('ch01') String channel1SearchPattern,
    @Default('ch02') String channel2SearchPattern,
    @Default('ch03') String channel3SearchPattern,
    @Default('ch04') String channel4SearchPattern,
    @Default('overlay') String overlaySearchPattern,
    @Default('CD4') String channel0ProteinName,
    @Default('Glucagon') String channel1ProteinName,
    @Default('Insulin') String channel2ProteinName,
    @Default('CD8') String channel3ProteinName,
    @Default('???') String channel4ProteinName,
  }) = _ConvexHullState;

  factory ConvexHullState.fromJson(Map<String, dynamic> json) => _$ConvexHullStateFromJson(json);
}
