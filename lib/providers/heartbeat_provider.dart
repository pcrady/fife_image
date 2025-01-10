import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heartbeat_provider.g.dart';

@riverpod
class Heartbeat extends _$Heartbeat {
  static const heartBeatDuration = Duration(seconds: 5);
  static const testInterval = Duration(seconds: 1);

  @override
  Future<bool> build() async {
    await ref.read(workingDirProvider.future);
    _checkForRunningServer();
    return _testServer();
  }

  Future<void> _checkForRunningServer() async {
    final dio = Dio();
    final workingDir = ref.read(workingDirProvider.notifier);
    await workingDir.writeToAppLog('Checking for running server.');
    try {
      await dio.get(server);
      await workingDir.writeToAppLog('Server already running.');
    } catch (err) {
      await workingDir.writeToAppLog('No server detected. Starting server.');
      await _runExecutable();
    }
  }

  Future<void> _runExecutable() async {
    final appExecutable = File(Platform.resolvedExecutable).absolute.path;
    final executableDir = File(appExecutable).parent;
    final mainProgram = File('${executableDir.path}/main');

    final args = SubprocessArgs(binary: mainProgram);
    Worker worker = Worker();
    await worker.spawn();
    worker.startServer(args);
  }

  Future<void> _heartBeat() async {
    while (true) {
      final dio = Dio();
      final workingDir = ref.read(workingDirProvider.notifier);
      await workingDir.writeToAppLog('heartbeat: ${DateTime.now().millisecondsSinceEpoch}');
      await dio.post('${server}heartbeat');
      await Future.delayed(heartBeatDuration);
    }
  }

  Future<bool> _testServer() async {
    bool shouldTest = true;
    while (shouldTest) {
      final dio = Dio();
      final workingDir = ref.read(workingDirProvider.notifier);

      try {
        ref.read(appDataProvider.notifier).setLoadingTrue();
        await dio.get(server);
        final workingDirFromDisk = ref.read(workingDirProvider).value;
        await ref.read(workingDirProvider.notifier).setWorkingDir(workingDir: workingDirFromDisk);
        await workingDir.writeToAppLog('connected to server');
        _heartBeat();
        shouldTest = false;
      } catch (err) {
        await workingDir.writeToAppLog('connecting to server');
        await Future.delayed(testInterval);
      }
    }
    return true;
  }
}

class SubprocessArgs {
  File binary;

  SubprocessArgs({
    required this.binary,
  });
}

class Worker {
  late SendPort _mainSendPort;
  final Completer<void> _isolateReady = Completer.sync();
  bool serverStarted = false;

  Future<void> spawn() async {
    final mainReceivePort = ReceivePort();
    mainReceivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_isolate, mainReceivePort.sendPort);
  }

  static void _isolate(SendPort port) {
    final isolateReceivePort = ReceivePort();
    port.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic args) async {
      if (args is SubprocessArgs) {
        final process = await Process.start(args.binary.path, []);
        port.send(true);
        final exitCode = await process.exitCode;
        port.send(exitCode);
      }
    });
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _mainSendPort = message;
      _isolateReady.complete();
    } else if (message is bool) {
      serverStarted = message;
    } else {
      logger.i(message);
    }
  }

  // sends message to isolate
  Future<void> startServer(SubprocessArgs args) async {
    await _isolateReady.future;
    _mainSendPort.send(args);
  }
}
