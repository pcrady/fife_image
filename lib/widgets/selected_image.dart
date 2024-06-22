import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/widgets/selected_image_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImage extends ConsumerWidget {
  final AbstractImage image;

  const SelectedImage({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.precise,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: SelectedImagePaint(image: image),
          ),
        ),
        Text(
          image.name,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
