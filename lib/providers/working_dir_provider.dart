import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:flutter/foundation.dart';
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

  String? get appLogFile {
    final dir = state.valueOrNull;
    if (dir != null) {
      return '$dir/app.log';
    }
    return null;
  }

  String? get serverLogFile {
    final dir = state.valueOrNull;
    if (dir != null) {
      return '$dir/server.log';
    }
    return null;
  }

  Future<void> writeToAppLog(String message) async {
    if (kDebugMode) {
      print(message);
    }
    if (appLogFile == null) return;
    final File logFile = await File(appLogFile!).create(recursive: true, exclusive: false);
    logFile.writeAsStringSync('$message\n', mode: FileMode.append);
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