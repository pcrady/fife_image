import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'working_dir_provider.g.dart';

@Riverpod(keepAlive: true)
class WorkingDir extends _$WorkingDir {
  final _dio = Dio();
  static const _workingDirKey = 'working_dir';

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    String? workingDir = prefs.getString(_workingDirKey);
    if (workingDir == null) {
      String? home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      workingDir = home != null ? '$home/FifeImage' : '';
    }
    return workingDir;
  }

  Future<void> setWorkingDir({required String? workingDir}) async {
    if (workingDir == null) return;

    await _dio.post(
      '$server/config',
      data: {_workingDirKey: workingDir},
    );

    state = AsyncData(workingDir);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workingDirKey, workingDir);
  }
}