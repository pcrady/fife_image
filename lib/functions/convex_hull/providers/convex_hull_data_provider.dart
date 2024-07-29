import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:html' as html;

// flutter pub run build_runner build
part 'convex_hull_data_provider.g.dart';

@riverpod
class ConvexHullData extends _$ConvexHullData {
  final _dio = Dio();

  @override
  FutureOr<Map> build() async {
    final response = await _dio.get('$server/data');
    return Map.from(response.data);
  }

  void _downloadFile(String url, String filename) {
    html.HttpRequest.request(url, responseType: 'blob').then((response) {
      final blob = response.response as html.Blob;
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    });
  }

  void downloadData() {
    const url = '$server/download';
    _downloadFile(url, 'convex_data_hull.csv');
  }
}
