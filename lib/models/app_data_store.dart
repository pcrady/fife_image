import 'package:fife_image/models/abstract_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'app_data_store.freezed.dart';
part 'app_data_store.g.dart';

@freezed
class AppDataStore with _$AppDataStore {

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory AppDataStore({
    List<AbstractImage>? images,
    AbstractImage? selectedImage,
  }) = _AppDataStore;

  factory AppDataStore.fromJson(Map<String, dynamic> json) => _$AppDataStoreFromJson(json);
}
