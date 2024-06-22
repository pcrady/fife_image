import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/function_controls.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RightSide extends ConsumerWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appData = ref.watch(appDataProvider);
    final leftMenu = appData.leftMenu;

    if (leftMenu == LeftMenuEnum.images) {
      return const SelectedImage();
    } else if (leftMenu == LeftMenuEnum.functionSettings) {
      return Container();
    } else {
      return const FunctionControls();
    }
  }
}
