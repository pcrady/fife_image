import 'package:dio/dio.dart';
import 'package:fife_image/lib/fife_image_helpers.dart';
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

class _ImageThumbnailCardState extends ConsumerState<ImageThumbnailCard> with FifeImageHelpers {
  bool mouseHover = false;


  @override
  Widget build(BuildContext context) {
    final data = ref.watch(appDataProvider);
    final selectedImage = data.selectedImage;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: BoxDecoration(
          border: widget.image.imagePath == selectedImage?.imagePath ? Border.all(color: Colors.green, width: 2) : null,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
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
              clipBehavior: Clip.antiAlias,
              children: [
                widget.image.thumbnail != null ? Image(
                  key: UniqueKey(),
                  image: widget.image.thumbnail!,
                ) : Container(),
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
                            try {
                              await ref.read(imagesProvider.notifier).deleteImageFromServer(
                                image: widget.image,
                              );
                              final deleteCallback = widget.deleteCallback;
                              if (deleteCallback != null) {
                                deleteCallback();
                              }
                              if (!context.mounted) return;
                            } on DioException catch (err, stack) {
                              fifeImageSnackBar(
                                context: context,
                                message: err.response?.data.toString() ?? 'An error has occurred',
                                dioErr: err,
                                stack: stack,
                              );
                            } catch (err, stack) {
                              fifeImageSnackBar(
                                context: context,
                                message: err.toString(),
                                err: err,
                                stack: stack,
                              );
                            } finally {
                              ref.read(appDataProvider.notifier).setLoadingFalse();
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
      ),
    );
  }
}
