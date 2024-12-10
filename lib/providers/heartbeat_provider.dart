import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heartbeat_provider.g.dart';

@riverpod
class Heartbeat extends _$Heartbeat {
  static const heartBeatDuration = Duration(seconds: 5);
  static const testInterval = Duration(seconds: 1);
  static String _logFilePath = '';

  @override
  Future<bool> build() async {
    _checkForRunningServer();
    return _testServer();
  }

  String get logFilePath => _logFilePath;

  Future<void> _checkForRunningServer() async {
    final dio = Dio();
    if (kDebugMode) {
      print('Checking for running server');
    }
    try {
      await dio.get(server);
      if (kDebugMode) {
        print('Server already running');
      }
    } catch (err) {
      if (kDebugMode) {
        print('No server detected. Starting server.');
      }
      await _runExecutable();
    }
  }

  Future<void> _runExecutable() async {
    final logDir = await getApplicationCacheDirectory();
    _logFilePath = '${logDir.path}/fife_image.log';
    await Isolate.spawn(_runProcess, _logFilePath);
  }

  Future<void> _heartBeat() async {
    while (true) {
      final dio = Dio();
      await dio.post('${server}heartbeat');
      await Future.delayed(heartBeatDuration);
    }
  }

  Future<bool> _testServer() async {
    bool shouldTest = true;
    while (shouldTest) {
      final dio = Dio();
      try {
        ref.read(appDataProvider.notifier).setLoadingTrue();
        await dio.get(server);
        final workingDirFromDisk = ref.read(workingDirProvider).value;
        await ref.read(workingDirProvider.notifier).setWorkingDir(workingDir: workingDirFromDisk);
        if (kDebugMode) {
          print('connected to server');
        }
        _heartBeat();
        shouldTest = false;
      } catch (err) {
        if (kDebugMode) {
          print('connecting to server');
        }
        await Future.delayed(testInterval);
      }
    }
    return true;
  }
}

void _runProcess(
  String logFilePath,
) async {
  final File logFile = File(logFilePath);
  final Process process = await Process.start(serverPath, []);
  if (kDebugMode) {
    print('logging to: $logFilePath');
  }
  process.stdout.transform(const SystemEncoding().decoder).listen((output) {
    logFile.writeAsStringSync(output, mode: FileMode.append);
  });

  process.stderr.transform(const SystemEncoding().decoder).listen((error) {
    logFile.writeAsStringSync(error, mode: FileMode.append);
  });

  final exitCode = await process.exitCode;
  logFile.writeAsStringSync('Process exited with code: $exitCode\n', mode: FileMode.append);
}
