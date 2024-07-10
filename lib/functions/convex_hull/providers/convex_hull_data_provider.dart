import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_data_model.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'convex_hull_data_provider.g.dart';

@riverpod
class ConvexHullData extends _$ConvexHullData {
  final _dio = Dio();

  @override
  FutureOr<Map<String, ConvexHullDataModel>> build() async {
    final response = await _dio.get('$server/data');
    final data = response.data;
    Map<String, ConvexHullDataModel> convexHullData = data.map<String, ConvexHullDataModel>((key, entry) {
      return MapEntry<String, ConvexHullDataModel>(key, ConvexHullDataModel.fromJson(entry));
    });
    return convexHullData;
  }
}
