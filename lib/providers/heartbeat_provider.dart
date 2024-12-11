import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
    writeToLog('Checking for running server.');
    try {
      await dio.get(server);
      writeToLog('Server already running.');
    } catch (err) {
      writeToLog('No server detected. Starting server.');
      await _runExecutable();
    }
  }

  Future<void> _runExecutable() async {
    final supportDir = await getApplicationSupportDirectory();
    final logFile = File('${supportDir.path}/fife_image.log');

    final appExecutable = File(Platform.resolvedExecutable).absolute.path;
    final executableDir = File(appExecutable).parent;
    final mainProgram = File('${executableDir.path}/main');
    logger.i(mainProgram.path);

    final args = SubprocessArgs(
      rootIsolateToken: RootIsolateToken.instance!,
      logFile: logFile,
      tempFile: mainProgram,
    );
    await Isolate.spawn(_runProcess, args);
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

        writeToLog('connected to server');
        _heartBeat();
        shouldTest = false;
      } catch (err) {
        writeToLog('connecting to server');
        await Future.delayed(testInterval);
      }
    }
    return true;
  }
}

class SubprocessArgs {
  RootIsolateToken rootIsolateToken;
  File logFile;
  File tempFile;

  SubprocessArgs({
    required this.rootIsolateToken,
    required this.logFile,
    required this.tempFile,
  });
}

void _runProcess(SubprocessArgs args) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(args.rootIsolateToken);

  try {
    final Process process = await Process.start(args.tempFile.path, []);
    writeToLog('logging to: ${args.logFile.path}');

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
    writeToLog('error: ${err.toString()} \nstack: ${stack.toString()}');
    if (kDebugMode) {
      print(err);
    }
  }
}

void writeToLog(String message) {
  if (kDebugMode) {
    print(message);
  } else {
    final File logFile = File('/Users/petercrady/fuck.txt');
    logFile.writeAsStringSync('$message\n', mode: FileMode.append);
  }
}
