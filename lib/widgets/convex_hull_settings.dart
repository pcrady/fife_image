import 'package:fife_image/lib/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullSettings extends ConsumerStatefulWidget {
  const ConvexHullSettings({super.key});

  @override
  ConsumerState<ConvexHullSettings> createState() => _ConvexHullSettingsState();
}

class _ConvexHullSettingsState extends ConsumerState<ConvexHullSettings> {
  late TextEditingController channel1Controller;
  late TextEditingController channel2Controller;
  late TextEditingController channel3Controller;
  late TextEditingController channel4Controller;
  late TextEditingController overlayController;
  late TextEditingController channel1NameController;
  late TextEditingController channel2NameController;
  late TextEditingController channel3NameController;
  late TextEditingController channel4NameController;

  @override
  void initState() {
    channel1Controller = TextEditingController(text: 'ch01');
    channel2Controller = TextEditingController(text: 'ch02');
    channel3Controller = TextEditingController(text: 'ch03');
    channel4Controller = TextEditingController(text: 'ch04');
    overlayController = TextEditingController(text: 'overlay');
    channel1NameController = TextEditingController();
    channel2NameController = TextEditingController();
    channel3NameController = TextEditingController();
    channel4NameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    channel1Controller.dispose();
    channel2Controller.dispose();
    channel3Controller.dispose();
    channel4Controller.dispose();
    overlayController.dispose();
    channel1NameController.dispose();
    channel2NameController.dispose();
    channel3NameController.dispose();
    channel4NameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = constraints.maxWidth / 2.0 - 4.0;

        return Column(
          children: [
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel1Controller,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 1 Search Pattern',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 1 Search Pattern',
                    ),
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel1NameController,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 1 Protein Name',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 1 Protein Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel2Controller,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 2 Search Pattern',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 2 Search Pattern',
                    ),
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel2NameController,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 2 Protein Name',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 2 Protein Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel3Controller,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 3 Search Pattern',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 3 Search Pattern',
                    ),
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel3NameController,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 3 Protein Name',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 3 Protein Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel4Controller,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 4 Search Pattern',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 4 Search Pattern',
                    ),
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: TextField(
                    controller: channel1NameController,
                    decoration: const InputDecoration(
                      hintText: 'Set Channel 4 Protein Name',
                      border: OutlineInputBorder(),
                      labelText: 'Channel 4 Protein Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: overlayController,
              decoration: const InputDecoration(
                hintText: 'Overlay Search Pattern',
                border: OutlineInputBorder(),
                labelText: 'Overlay Search Pattern',
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Start'),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
