import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'app_info.freezed.dart';
part 'app_info.g.dart';

@freezed
class AppInfoStore with _$AppInfoStore {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory AppInfoStore({
    @Default('') String serverVersion,
    @Default('') String appVersion,
  }) = _AppInfoStore;

  factory AppInfoStore.fromJson(Map<String, dynamic> json) => _$AppInfoStoreFromJson(json);
}