import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/lib/app_logger.dart';
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
            await ref.read(imagesProvider.notifier).deleteImageFromServer(image: image);
          },
          child: Stack(
            children: [
              _NetworkImage(
                url: image.url,
                md5Hash: image.md5Hash ?? '',
              ),
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
  final String md5Hash;

  const _NetworkImage({
    required this.url,
    required this.md5Hash,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      cacheKey: md5Hash,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorListener: (error) {
        logger.e(error);
      },
    );
  }
}
