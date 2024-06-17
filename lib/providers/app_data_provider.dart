import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:fife_image/models/convex_hull_state.dart';
import 'package:fife_image/models/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@riverpod
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

  void setConvexHullState({required ConvexHullState convexHullState}) {
    state = state.copyWith(convexHullState: convexHullState);
  }
}
