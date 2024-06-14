import 'dart:io';

import 'package:fife_image/lib/app_logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FifeImageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  const FifeImageAppBar({
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Fife Image'),
      actions: [
        IconButton(
          onPressed: () async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result != null) {
                for (final file in result.files) {
                  logger.i(file.size);
                }
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
