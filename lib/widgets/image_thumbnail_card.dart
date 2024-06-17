import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageCard extends ConsumerWidget {
  final AbstractImage image;

  const ImageCard({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            ref.read(appDataProvider.notifier).selectImage(image: image);
          },
          onLongPress: () async {
            await ref.read(imagesProvider.notifier).deleteImage(image: image);
          },
          child: Stack(
            children: [
              _NetworkImage(url: image.url),
              Positioned(
                left: 8.0,
                bottom: 8.0,
                child: Text(
                  image.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  final String url;

  const _NetworkImage({
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const CircularProgressIndicator(),
    );
  }
}
