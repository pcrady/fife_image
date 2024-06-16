import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageList extends ConsumerWidget {
  const ImageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(imagesProvider);
    return appData.when(
      data: (data) {
        final images = data;

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return ImageCard(image: images[index]);
          },
        );
      },
      error: (err, stack) {
        logger.e(err, stackTrace: stack);
        return Container();
      },
      loading: () {
        return Container();
      },
    );
  }
}
