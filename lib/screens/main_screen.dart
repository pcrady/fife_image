import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/heartbeat_provider.dart';
import 'package:fife_image/widgets/fife_image_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool loading = true;
  late ScrollController leftController;
  late ScrollController rightController;

  @override
  void initState() {
    leftController = ScrollController();
    rightController = ScrollController();
    ref.listenManual(heartbeatProvider, (previous, next) {
      setState(() {
        loading = !(next.value ?? false);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    leftController.dispose();
    rightController.dispose();
    super.dispose();
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
                  child: RawScrollbar(
                    thumbColor: Colors.white30,
                    controller: leftController,
                    radius: const Radius.circular(20),
                    child: SingleChildScrollView(
                      controller: leftController,
                      child: leftSide,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RawScrollbar(
                    thumbColor: Colors.white30,
                    radius: const Radius.circular(20),
                    controller: rightController,
                    child: SingleChildScrollView(
                      controller: rightController,
                      child: rightSide,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
