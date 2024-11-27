import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/fife_image_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*class MainScreen extends ConsumerWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final settings = ref.watch(appDataProvider);
    final function = imageFunctions.singleWhere(
      (function) => function.imageFunction == settings.function,
    );
    final leftSide = function.leftSide;
    final rightSide = function.rightSide;

    return Scaffold(
      appBar: const FifeImageAppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: leftSide),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(child: rightSide),
            ),
          )
        ],
      ),
    );
  }
}*/

class MainScreen extends ConsumerStatefulWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool loading = true;

  Future<void> testServer() async {
    final dio = Dio();
    try {
      await dio.get(server);
      ref.invalidate(imagesProvider);
      setState(() => loading = false);
      ref.read(appDataProvider.notifier).setLoadingFalse();
    } catch (err) {
      print('connecting to server');
      await Future.delayed(const Duration(seconds: 1));
      testServer();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testServer();
      ref.read(appDataProvider.notifier).setLoadingTrue();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appDataProvider);
    final function = imageFunctions.singleWhere(
      (function) => function.imageFunction == settings.function,
    );
    final leftSide = function.leftSide;
    final rightSide = function.rightSide;

    return Opacity(
      opacity: loading ? 0.5 : 1.0,
      child: IgnorePointer(
        ignoring: loading,
        child: Scaffold(
          appBar: const FifeImageAppBar(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(child: leftSide),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(child: rightSide),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
