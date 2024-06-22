import 'package:fife_image/widgets/image_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoFunctionLeftSide extends ConsumerWidget {
  const NoFunctionLeftSide({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ImageList();
  }
}
