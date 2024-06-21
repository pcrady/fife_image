import 'package:fife_image/lib/app_logger.dart';
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
    logger.i(image?.url);


    if (image != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.precise,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: SelectedImagePaint(image: image),
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
