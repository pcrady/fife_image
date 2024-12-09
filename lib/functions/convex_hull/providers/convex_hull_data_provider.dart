import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_data_provider.g.dart';

@riverpod
class ConvexHullData extends _$ConvexHullData {
  final _dio = Dio();

  @override
  FutureOr<Map> build() async {
    ref.watch(workingDirProvider);
    final response = await _dio.get('$server/data');
    return Map.from(response.data);
  }
}
