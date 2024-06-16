import 'package:flutter/material.dart';

class ConvexHullResults extends StatelessWidget {
  const ConvexHullResults({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Channel 1'),
            Text('Channel 2'),
            Text('Channel 3'),
            Text('Channel 4'),
            Text('Overlay'),
          ],
        )
      ],
    );
  }
}
