import 'package:fife_image/widgets/fife_image_app_bar.dart';
import 'package:fife_image/widgets/image_list.dart';
import 'package:fife_image/widgets/left_side.dart';
import 'package:fife_image/widgets/right_side.dart';
import 'package:fife_image/widgets/selected_image.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  static const route = '/';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FifeImageAppBar(
        bottom: AppBarBottom(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: LeftSide(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: const [
                  RightSide(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
