import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heartbeat_provider.g.dart';

// TODO make sure log file locations change when working dir changes
@riverpod
class Heartbeat extends _$Heartbeat {
  static const heartBeatDuration = Duration(seconds: 5);
  static const testInterval = Duration(seconds: 1);
  static late String _appLogPath;
  static late String _serverLogPath;

  @override
  Future<bool> build() async {
    final workingDirFromDisk = await ref.read(workingDirProvider.future);
    _appLogPath = '$workingDirFromDisk/app.log';
    _serverLogPath = '$workingDirFromDisk/server.log';
    _checkForRunningServer();
    return _testServer();
  }

  String get appLogPath => _appLogPath;
  String get serverLogPath => _serverLogPath;

  Future<void> _writeToAppLog(String message) async {
    if (kDebugMode) {
      print(message);
    }
    final File logFile = await File(_appLogPath).create(recursive: true, exclusive: false);
    logFile.writeAsStringSync('$message\n', mode: FileMode.append);
  }

  Future<void> _checkForRunningServer() async {
    final dio = Dio();
    await _writeToAppLog('Checking for running server.');
    try {
      await dio.get(server);
      await _writeToAppLog('Server already running.');
    } catch (err) {
      await _writeToAppLog('No server detected. Starting server.');
      await _runExecutable();
    }
  }

  Future<void> _runExecutable() async {
    final logFile = await File(_serverLogPath).create(recursive: true, exclusive: false);
    final appExecutable = File(Platform.resolvedExecutable).absolute.path;
    final executableDir = File(appExecutable).parent;
    final mainProgram = File('${executableDir.path}/main');

    final args = _SubprocessArgs(
      rootIsolateToken: RootIsolateToken.instance!,
      logFile: logFile,
      binary: mainProgram,
    );
    await Isolate.spawn(_runProcess, args);
  }

  Future<void> _heartBeat() async {
    while (true) {
      final dio = Dio();
      await _writeToAppLog('heartbeat: ${DateTime.now().millisecondsSinceEpoch}');
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

        await _writeToAppLog('connected to server');
        _heartBeat();
        shouldTest = false;
      } catch (err) {
        await _writeToAppLog('connecting to server');
        await Future.delayed(testInterval);
      }
    }
    return true;
  }
}


class _SubprocessArgs {
  RootIsolateToken rootIsolateToken;
  File logFile;
  File binary;

  _SubprocessArgs({
    required this.rootIsolateToken,
    required this.logFile,
    required this.binary,
  });
}


void _runProcess(_SubprocessArgs args) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args.rootIsolateToken);

  try {
    final Process process = await Process.start(args.binary.path, []);

    process.stdout.transform(const SystemEncoding().decoder).listen((output) {
      args.logFile.writeAsStringSync(output, mode: FileMode.append);
    });

    process.stderr.transform(const SystemEncoding().decoder).listen((error) {
      args.logFile.writeAsStringSync(error, mode: FileMode.append);
    });

    final exitCode = await process.exitCode;
    args.logFile.writeAsStringSync(
      'Process exited with code: $exitCode\n',
      mode: FileMode.append,
    );
  } catch (err, stack) {
    args.logFile.writeAsStringSync('error: ${err.toString()} \nstack: ${stack.toString()}');
    if (kDebugMode) {
      print(err);
    }
  }
}
