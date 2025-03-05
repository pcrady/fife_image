
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
  late ScrollController rightController;
  late Provider<FunctionsEnum> functionProvider;

  @override
  void initState() {
    rightController = ScrollController();

    ref.listenManual(heartbeatProvider, (previous, next) {
      setState(() {
        loading = !(next.value ?? false);
      });
    });

    functionProvider = Provider<FunctionsEnum>((ref) {
      final settings = ref.watch(appDataProvider);
      return settings.function;
    });

    super.initState();
  }

  @override
  void dispose() {
    rightController.dispose();
    logger.i('fuck');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final functionEnum = ref.watch(functionProvider);

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
                  child: functionEnum.leftSide,
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
                      child: functionEnum.rightSide,
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
