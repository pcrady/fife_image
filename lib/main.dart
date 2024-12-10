import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/fife_image_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<void> testServer() async {
  final dio = Dio();
  if (kDebugMode) {
    print('Testing server');
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
    await runExecutable();
  }
}

Future<void> runExecutable() async {
  const serverPath = 'server/dist/main';
  await Isolate.spawn(runProcess, serverPath);
}

void runProcess(String execPath) async {
  final Process process = await Process.start(execPath, []);
  process.stdout.transform(const SystemEncoding().decoder).listen((output) {});
  process.stderr.transform(const SystemEncoding().decoder).listen((error) {});

  final exitCode = await process.exitCode;
  if (kDebugMode) {
    print('Process exited with code: $exitCode');
  }
}

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
  testServer();
}

class MyApp extends StatelessWidget with FifeImageRouter {
  MyApp({super.key});

  static const unselectedColor = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fife Image',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xff1f004a),
          foregroundColor: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        scaffoldBackgroundColor: const Color(0xff101418),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unselectedColor),
          ),
          labelStyle: TextStyle(color: unselectedColor),
          hintStyle: TextStyle(color: unselectedColor),
          focusColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
