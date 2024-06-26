import 'package:cached_network_image/cached_network_image.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageThumbnailCard extends ConsumerStatefulWidget {
  final AbstractImage image;
  final void Function()? callback;
  final void Function()? deleteCallback;

  const ImageThumbnailCard({
    required this.image,
    this.callback,
    this.deleteCallback,
    super.key,
  });

  @override
  ConsumerState<ImageThumbnailCard> createState() => _ImageThumbnailCardState();
}

class _ImageThumbnailCardState extends ConsumerState<ImageThumbnailCard> {
  bool mouseHover = false;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(appDataProvider);
    final selectedImage = data.selectedImage;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: widget.image == selectedImage
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: Colors.green,
                width: 4.0,
              ),
            )
          : null,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => mouseHover = true);
        },
        onExit: (_) {
          setState(() => mouseHover = false);
        },
        child: GestureDetector(
          onTap: () {
            ref.read(appDataProvider.notifier).selectImage(image: widget.image);
            final callback = widget.callback;
            if (callback != null) {
              callback();
            }
          },
          child: Stack(
            children: [
              _NetworkImage(
                url: widget.image.url,
                md5Hash: widget.image.md5Hash ?? '',
              ),
              mouseHover
                  ? Positioned(
                      right: 4.0,
                      top: 4.0,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        onTap: () async {
                          await ref.read(imagesProvider.notifier).deleteImageFromServer(image: widget.image);
                          final deleteCallback = widget.deleteCallback;
                          if (deleteCallback != null) {
                            deleteCallback();
                          }
                        },
                      ),
                    )
                  : Container(),
              Positioned(
                left: 8.0,
                bottom: 8.0,
                child: Text(
                  widget.image.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
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
