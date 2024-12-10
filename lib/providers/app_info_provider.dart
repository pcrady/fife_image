import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/models/app_info.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_provider.g.dart';

@riverpod
class AppInfo extends _$AppInfo {
  final _dio = Dio();

  @override
  Future<AppInfoStore> build() async {
    ref.watch(workingDirProvider);
    final response = await _dio.get('${server}version');
    final serverData = AppInfoStore.fromJson(response.data);
    final packageInfo = await PackageInfo.fromPlatform();
    return serverData.copyWith(appVersion: packageInfo.version);
  }
}
