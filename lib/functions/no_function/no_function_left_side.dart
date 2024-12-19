import 'package:fife_image/widgets/image_list.dart';
import 'package:fife_image/widgets/working_directory_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoFunctionLeftSide extends ConsumerWidget {
  const NoFunctionLeftSide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        WorkingDirectorySelector(),
        SizedBox(height: 8.0),
        Expanded(
          child: ImageList(),
        ),
      ],
    );
  }
}
