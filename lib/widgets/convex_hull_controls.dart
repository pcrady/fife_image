import 'package:fife_image/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullControls extends ConsumerStatefulWidget {
  const ConvexHullControls({super.key});

  @override
  ConsumerState<ConvexHullControls> createState() => _ConvexHullControlsState();
}

class _ConvexHullControlsState extends ConsumerState<ConvexHullControls> {
  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);
    final convexHullState = appData.convexHullState;

    if (appData.selectedImage == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select the region of highest background signal.',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Clear'),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Next'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
