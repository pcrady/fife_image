import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoFunctionRightSide extends ConsumerWidget {
  const NoFunctionRightSide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(appDataProvider);
    final image = appData.selectedImage;
    if (image != null) {
      return SelectedImage(image: image);
    } else {
      return Container();
    }
  }
}
