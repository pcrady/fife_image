import 'dart:convert';
import 'dart:io';

import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_results.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

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
    final jsonFile = _getConfigFile();
    if (!jsonFile.existsSync()) {
      return const ConvexHullConfigModel();
    } else {
      final config = json.decode(jsonFile.readAsStringSync());
      return ConvexHullConfigModel.fromJson(config);
    }
  }

  Future<void> setConvexHullConfig({required ConvexHullConfigModel convexHullConfigModel}) async {
    final jsonFile = _getConfigFile();
    const encoder =  JsonEncoder.withIndent('  ');
    final formattedJson = encoder.convert(convexHullConfigModel.toJson());
    await jsonFile.writeAsString(formattedJson);
    state = convexHullConfigModel;
  }

  void setLeftMenu({required LeftMenuEnum leftMenu}) {
    state = state.copyWith(leftMenuEnum: leftMenu);
  }

  void setActiveImage({required AbstractImage? activeImage})  {
    state = state.copyWith(
      activeImage: activeImage,
      activeResults: null,
      activeImageSetBaseName: activeImage?.baseName,
    );
  }

  void setActiveResults({required ConvexHullResults? results})  {
    state = state.copyWith(
      activeImage: null,
      activeResults: results,
      activeImageSetBaseName: results?.simplex?.baseName,
    );
    ref.read(appDataProvider.notifier).selectImage(image: null);
  }
}