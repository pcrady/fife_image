import 'package:fife_image/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResultsCard extends ConsumerWidget {
  final double cardSize;

  const ResultsCard({
    required this.cardSize,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(appDataProvider.notifier).selectImage(image: null);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: Colors.green,
              width: 4.0,
            ),
          ),
          color: Colors.purpleAccent,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.flaskVial,
                size: cardSize * 0.5,
              ),
              const Text(
                'Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
