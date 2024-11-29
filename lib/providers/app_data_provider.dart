import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_data_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@Riverpod(keepAlive: true)
class AppData extends _$AppData {
  final _dio = Dio();
  static const _workingDirKey = 'working_dir';

  @override
  AppDataStore build() {
    return const AppDataStore();
  }

  Future<void> setWorkingDir({required String? workingDir}) async {
    if (workingDir == null) return;
    state = state.copyWith(workingDirectory: workingDir);

    await _dio.post(
      '$server/config',
      data: {_workingDirKey: state.workingDirectory},
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workingDirKey, state.workingDirectory!);

    ref.invalidate(imagesProvider);
    ref.invalidate(convexHullImageSetsProvider);
    ref.invalidate(convexHullDataProvider);
    ref.invalidate(convexHullConfigProvider);
  }

  Future<String?> getWorkingDirFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_workingDirKey);
  }

  void setFunction({required FunctionsEnum function}) {
    state = state.copyWith(function: function);
  }

  void selectImage({required AbstractImage? image}) {
    state = state.copyWith(selectedImage: image);
  }

  void setLoadingTrue() {
    state = state.copyWith(loading: true);
  }

  void setLoadingFalse() {
    state = state.copyWith(loading: false);
  }
}
