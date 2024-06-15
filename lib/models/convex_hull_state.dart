import 'package:fife_image/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_state.freezed.dart';
part 'convex_hull_state.g.dart';

@freezed
class ConvexHullState with _$ConvexHullState {

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory ConvexHullState({
    @Default(ConvexHullStep.first) ConvexHullStep step,
  }) = _ConvexHullState;

  factory ConvexHullState.fromJson(Map<String, dynamic> json) => _$ConvexHullStateFromJson(json);
}