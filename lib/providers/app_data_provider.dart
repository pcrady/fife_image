import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@riverpod
class AppData extends _$AppData {
  @override
  AppDataStore build() {
    return const AppDataStore();
  }

  void setImages({required List<AbstractImage> images}) {
    final data = state.copyWith(images: images);
    state = data;
  }

  void addImage({required AbstractImage image}) {
    var images = List<AbstractImage>.from(state.images ?? []);
    images.add(image);
    state = state.copyWith(images: images);
  }

  void removeImage({required AbstractImage image}) {
    var images = List<AbstractImage>.from(state.images ?? []);
    images.remove(image);
    state = state.copyWith(images: images);
  }

  void selectImage({required AbstractImage? image}) {
    if (image != null) {
      final index = state.images?.indexOf(image);
      state = state.copyWith(selectedImageIndex: index);
    } else {
      state = state.copyWith(selectedImageIndex: null);
    }
  }
}