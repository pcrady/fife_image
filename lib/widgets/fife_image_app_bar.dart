import 'dart:io';

import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FifeImageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  const FifeImageAppBar({
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Fife Image'),
      actions: [
        IconButton(
          onPressed: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result != null) {
                List<AbstractImage> images = result.files.map((file) => AbstractImage(file: file)).toList();
                ref.read(appDataProvider.notifier).setImages(images: images);
              }
            } catch (err, stack) {
              logger.e(err, stackTrace: stack);
            }
          },
          icon: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ],
    );
  }
}
