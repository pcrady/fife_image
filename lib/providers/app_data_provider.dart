import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/models/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@Riverpod(keepAlive: true)
class AppData extends _$AppData {
  @override
  AppDataStore build() {
    return const AppDataStore();
  }

  void setFunction({required FunctionsEnum function}) {
    if (function == FunctionsEnum.functions) {
      state = state.copyWith(
        function: function,
        leftMenu: LeftMenuEnum.images,
      );
    } else {
      state = state.copyWith(
        function: function,
        leftMenu: LeftMenuEnum.functionSettings,
      );
    }
  }

  void selectImage({required AbstractImage? image}) {
    state = state.copyWith(selectedImage: image);
  }

  void setMenuSetting({required LeftMenuEnum leftMenu}) {
    state = state.copyWith(leftMenu: leftMenu);
  }
}
