import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heartbeat_provider.g.dart';

@riverpod
class Heartbeat extends _$Heartbeat {
  static const heartBeatDuration = Duration(seconds: 5);
  static const testInterval = Duration(seconds: 1);

  @override
  Future<bool> build() async {
    _checkForRunningServer();
    return _testServer();
  }

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
    await Isolate.spawn(_runProcess, serverPath);
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

void _runProcess(String execPath) async {
  final Process process = await Process.start(execPath, []);
  process.stdout.transform(const SystemEncoding().decoder).listen((output) {
    print(output);
  });
  process.stderr.transform(const SystemEncoding().decoder).listen((error) {
    print(error);
  });
  final exitCode = await process.exitCode;
  if (kDebugMode) {
    print('Process exited with code: $exitCode');
  }
}
