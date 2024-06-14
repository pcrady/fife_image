import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImage extends ConsumerWidget {
  const SelectedImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(appDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        asyncData.when(
          data: (data) {
            final image = data.selectedImage;
            if (image != null) {
              return ImageCard(image: image);
            } else {
              return Container();
            }
          },
          error: (err, stack) {
            logger.e(err, stackTrace: stack);
            return Container();
          },
          loading: () {
            return Container();
          },
        )
      ],
    );
  }
}
