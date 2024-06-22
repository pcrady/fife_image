import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/models/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config_provider.g.dart';

@Riverpod(keepAlive: true)
class ConvexHullConfig extends _$ConvexHullConfig {
  @override
  ConvexHullConfigModel build() {
    return const ConvexHullConfigModel();
  }

  void setConvexHullConfig({required ConvexHullConfigModel convexHullConfigModel}) {
    state = convexHullConfigModel;
  }

  void setLeftMenu({required LeftMenuEnum leftMenu}) {
    state = state.copyWith(leftMenuEnum: leftMenu);
  }
}