import 'dart:convert';
import 'dart:io';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config_provider.g.dart';

@Riverpod(keepAlive: true)
class ConvexHullConfig extends _$ConvexHullConfig {
  @override
  ConvexHullConfigModel build() {
    final workingDir = ref.watch(workingDirProvider).value;
    final jsonFile = File('$workingDir/convex_hull_config.json');

    if (!jsonFile.existsSync()) {
      return const ConvexHullConfigModel();
    } else {
      final config = json.decode(jsonFile.readAsStringSync());
      return ConvexHullConfigModel.fromJson(config);
    }
  }

  Future<void> setConvexHullConfig({required ConvexHullConfigModel convexHullConfigModel}) async {
    final workingDir = ref.read(workingDirProvider).value;
    final jsonFile = File('$workingDir/convex_hull_config.json');
    const encoder = JsonEncoder.withIndent('  ');
    final formattedJson = encoder.convert(convexHullConfigModel.toJson());
    await jsonFile.writeAsString(formattedJson);
    state = convexHullConfigModel;
  }

  void setLeftMenu({required LeftMenuEnum leftMenu}) {
    state = state.copyWith(leftMenuEnum: leftMenu);
  }
}
