import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@Riverpod(keepAlive: true)
class AppData extends _$AppData {

  @override
  AppDataStore build() {
    ref.watch(workingDirProvider);
    return const AppDataStore();
  }

  void setFunction({required FunctionsEnum function}) {
    state = state.copyWith(function: function);
  }

  void selectImage({required AbstractImage? image}) {
    if (image != null) {
      setActiveResults(results: null);
    }
    state = state.copyWith(selectedImage: image);
  }

  void setActiveResults({required ConvexHullResults? results}) {
    if (results != null) {
      selectImage(image: null);
    }
    state = state.copyWith(activeResults: results);
  }

  void setLoadingTrue() {
    state = state.copyWith(loading: true);
  }

  void setLoadingFalse() {
    state = state.copyWith(loading: false);
  }
}
