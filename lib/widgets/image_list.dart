import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/image_thumbnail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ImageList extends ConsumerStatefulWidget {
  const ImageList({super.key});

  @override
  ConsumerState createState() => _ImageListState();
}

class _ImageListState extends ConsumerState<ImageList> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(imagesProvider);
    return appData.when(
      data: (data) {
        final images = data;

        return RawScrollbar(
          thumbColor: Colors.white30,
          controller: scrollController,
          radius: const Radius.circular(20),
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return ImageThumbnailCard(
                key: Key(images[index].hashCode.toString()),
                image: images[index],
              );
            },
          ),
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
