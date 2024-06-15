import 'package:fife_image/widgets/function_controls.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';

class RightSide extends StatelessWidget {
  const RightSide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SelectedImage(),
        FunctionControls(),
      ],
    );
  }
}
