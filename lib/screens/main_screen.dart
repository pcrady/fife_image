import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/fife_image_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
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
}
