import 'package:dio/dio.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/models/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@riverpod
class AppData extends _$AppData {
  @override
  AppDataStore build() {
    return const AppDataStore();
  }

  Future<void> setFunction({required FunctionsEnum function}) async {
    state = state.copyWith(function: function);
  }

  void selectImage({required AbstractImage? image}) async {
    state = state.copyWith(selectedImage: image);
  }

  void setMenuSetting({required LeftMenuEnum leftMenu}) async {
    state = state.copyWith(leftMenu: leftMenu);
  }
}
