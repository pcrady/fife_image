import 'package:fife_image/models/abstract_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner build
part 'app_data_store.freezed.dart';
part 'app_data_store.g.dart';

@freezed
class AppDataStore with _$AppDataStore {
  const factory AppDataStore({
    List<AbstractImage>? images,
    int? selectedImageIndex,
  }) = _AppDataStore;

  factory AppDataStore.fromJson(Map<String, dynamic> json) => _$AppDataStoreFromJson(json);
}
