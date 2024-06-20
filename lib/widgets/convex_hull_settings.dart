import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/convex_hull_config.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullSettings extends ConsumerStatefulWidget {
  const ConvexHullSettings({super.key});

  @override
  ConsumerState<ConvexHullSettings> createState() => _ConvexHullSettingsState();
}

class _ConvexHullSettingsState extends ConsumerState<ConvexHullSettings> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController channel0Controller;
  late TextEditingController channel1Controller;
  late TextEditingController channel2Controller;
  late TextEditingController channel3Controller;
  late TextEditingController channel4Controller;
  late TextEditingController overlayController;
  late TextEditingController channel0NameController;
  late TextEditingController channel1NameController;
  late TextEditingController channel2NameController;
  late TextEditingController channel3NameController;
  late TextEditingController channel4NameController;

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    final settings = ref.read(appDataProvider);
    final convexHullConfig = settings.convexHullConfig;
    channel0Controller = TextEditingController(text: convexHullConfig.channel0SearchPattern);
    channel1Controller = TextEditingController(text: convexHullConfig.channel1SearchPattern);
    channel2Controller = TextEditingController(text: convexHullConfig.channel2SearchPattern);
    channel3Controller = TextEditingController(text: convexHullConfig.channel3SearchPattern);
    channel4Controller = TextEditingController(text: convexHullConfig.channel4SearchPattern);
    overlayController = TextEditingController(text: convexHullConfig.overlaySearchPattern);
    channel0NameController = TextEditingController(text: convexHullConfig.channel0ProteinName);
    channel1NameController = TextEditingController(text: convexHullConfig.channel1ProteinName);
    channel2NameController = TextEditingController(text: convexHullConfig.channel2ProteinName);
    channel3NameController = TextEditingController(text: convexHullConfig.channel3ProteinName);
    channel4NameController = TextEditingController(text: convexHullConfig.channel4ProteinName);
    super.initState();
  }

  @override
  void dispose() {
    channel0Controller.dispose();
    channel1Controller.dispose();
    channel2Controller.dispose();
    channel3Controller.dispose();
    channel4Controller.dispose();
    overlayController.dispose();
    channel0NameController.dispose();
    channel1NameController.dispose();
    channel2NameController.dispose();
    channel3NameController.dispose();
    channel4NameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final halfWidth = constraints.maxWidth / 2.0 - 4.0;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: halfWidth,
                      child: TextFormField(
                        validator: validator,
                        controller: channel0Controller,
                        decoration: const InputDecoration(
                          hintText: 'Set Channel 0 Search Pattern',
                          border: OutlineInputBorder(),
                          labelText: 'Channel 0 Search Pattern',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: halfWidth,
                      child: TextFormField(
                        validator: validator,
                        controller: channel0NameController,
                        decoration: const InputDecoration(
                          hintText: 'Set Channel 0 Protein Name',
                          border: OutlineInputBorder(),
                          labelText: 'Channel 0 Protein Name',
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
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
                      child: TextFormField(
                        validator: validator,
                        controller: channel4NameController,
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
                TextFormField(
                  validator: validator,
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
                        onPressed: () {},
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final appData = ref.read(appDataProvider.notifier);
                            final convexHullConfig = ConvexHullConfig(
                              channel0SearchPattern: channel0Controller.text,
                              channel1SearchPattern: channel1Controller.text,
                              channel2SearchPattern: channel2Controller.text,
                              channel3SearchPattern: channel3Controller.text,
                              channel4SearchPattern: channel4Controller.text,
                              overlaySearchPattern: overlayController.text,
                              channel0ProteinName: channel0NameController.text,
                              channel1ProteinName: channel1NameController.text,
                              channel2ProteinName: channel2NameController.text,
                              channel3ProteinName: channel3NameController.text,
                              channel4ProteinName: channel4NameController.text,
                            );
                            appData.setConvexHullConfig(convexHullConfig: convexHullConfig);
                            appData.setMenuSetting(leftMenu: LeftMenuEnum.functionResults);
                          }
                        },
                        child: const Text('Start'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
