import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/selected_image_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImage extends ConsumerWidget {
  const SelectedImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(appDataProvider);
    final image = appData.selectedImage;

    if (image != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: SelectedImagePaint(url: image.url),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
