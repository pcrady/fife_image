import 'dart:convert';
import 'dart:io';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_config_provider.g.dart';

@Riverpod(keepAlive: true)
class ConvexHullConfig extends _$ConvexHullConfig {
  File _getConfigFile() {
    final workingDir = ref.watch(workingDirProvider).value;
    return File('$workingDir/convex_hull_config.json');
  }

  @override
  ConvexHullConfigModel build() {
    // TODO fix this I dont like that it reads from disk all the time and that i'm manually copying activeresults in
    // Maybe think about selected images being held elsewhere
    final appData = ref.watch(appDataProvider);
    final jsonFile = _getConfigFile();
    final state = stateOrNull;

    if (state != null) {
      return state.copyWith(
        activeImage: appData.selectedImage,
        activeImageSetBaseName: appData.selectedImage?.baseName,
        activeResults: null, // TODO this is weird investigate this
      );
    }

    if (!jsonFile.existsSync()) {
      return const ConvexHullConfigModel();
    } else {
      final config = json.decode(jsonFile.readAsStringSync());
      return ConvexHullConfigModel.fromJson(config);
    }
  }

  Future<void> setConvexHullConfig({required ConvexHullConfigModel convexHullConfigModel}) async {
    final jsonFile = _getConfigFile();
    const encoder = JsonEncoder.withIndent('  ');
    final strippedModel = convexHullConfigModel.copyWith(
      activeResults: null,
      activeImageSetBaseName: null,
    );
    final formattedJson = encoder.convert(strippedModel.toJson());
    await jsonFile.writeAsString(formattedJson);
    state = convexHullConfigModel;
  }

  void setLeftMenu({required LeftMenuEnum leftMenu}) {
    state = state.copyWith(leftMenuEnum: leftMenu);
  }

  void setActiveResults({required ConvexHullResults? results}) {
    ref.read(appDataProvider.notifier).selectImage(image: null);
    state = state.copyWith(
      activeImage: null,
      activeResults: results,
      activeImageSetBaseName: results?.simplex?.baseName,
    );
  }
}
