import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
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
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController unitsController;
  late String channel0Name;
  late String channel1Name;
  late String channel2Name;
  late String channel3Name;
  late String channel4Name;

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  @override
  void initState() {
    final convexHullConfig = ref.read(convexHullConfigProvider);
    channel0Controller = TextEditingController(text: convexHullConfig.channel0SearchPattern);
    channel1Controller = TextEditingController(text: convexHullConfig.channel1SearchPattern);
    channel2Controller = TextEditingController(text: convexHullConfig.channel2SearchPattern);
    channel3Controller = TextEditingController(text: convexHullConfig.channel3SearchPattern);
    channel4Controller = TextEditingController(text: convexHullConfig.channel4SearchPattern);
    overlayController = TextEditingController(text: convexHullConfig.overlaySearchPattern);
    widthController = TextEditingController(text: convexHullConfig.imageWidth.toString());
    heightController = TextEditingController(text: convexHullConfig.imageHeight.toString());
    unitsController = TextEditingController(text: convexHullConfig.units.toString());
    channel0Name = convexHullConfig.channel0ProteinName;
    channel1Name = convexHullConfig.channel1ProteinName;
    channel2Name = convexHullConfig.channel2ProteinName;
    channel3Name = convexHullConfig.channel3ProteinName;
    channel4Name = convexHullConfig.channel4ProteinName;
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
    widthController.dispose();
    heightController.dispose();
    unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final halfWidth = constraints.maxWidth / 2.0 - 4.0;
          final thirdWidth = constraints.maxWidth / 3.0 - 4.0;

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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: channel0Name,
                            onChanged: (String? value) {
                              setState(() {
                                channel0Name = value!;
                              });
                            },
                            items: proteins.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: channel1Name,
                            onChanged: (String? value) {
                              setState(() {
                                channel1Name = value!;
                              });
                            },
                            items: proteins.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: channel2Name,
                            onChanged: (String? value) {
                              setState(() {
                                channel2Name = value!;
                              });
                            },
                            items: proteins.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: channel3Name,
                            onChanged: (String? value) {
                              setState(() {
                                channel3Name = value!;
                              });
                            },
                            items: proteins.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: channel4Name,
                            onChanged: (String? value) {
                              setState(() {
                                channel4Name = value!;
                              });
                            },
                            items: proteins.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
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
                      width: thirdWidth,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty || (double.tryParse(value) == null)) {
                            return 'Please enter a numerical value';
                          }
                          return null;

                        },
                        controller: widthController,
                        decoration: const InputDecoration(
                          hintText: 'Image Width',
                          border: OutlineInputBorder(),
                          labelText: 'Image Width',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: thirdWidth,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty || (double.tryParse(value) == null)) {
                            return 'Please enter a numerical value';
                          }
                          return null;
                        },
                        controller: heightController,
                        decoration: const InputDecoration(
                          hintText: 'Image Height',
                          border: OutlineInputBorder(),
                          labelText: 'Image Height',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: thirdWidth,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          return null;
                        },
                        controller: unitsController,
                        decoration: const InputDecoration(
                          hintText: 'Length Units',
                          border: OutlineInputBorder(),
                          labelText: 'Length Units',
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
                            final oldConfig = ref.read(convexHullConfigProvider);
                            final newConfig = oldConfig.copyWith(
                              channel0SearchPattern: channel0Controller.text,
                              channel1SearchPattern: channel1Controller.text,
                              channel2SearchPattern: channel2Controller.text,
                              channel3SearchPattern: channel3Controller.text,
                              channel4SearchPattern: channel4Controller.text,
                              overlaySearchPattern: overlayController.text,
                              imageWidth: double.tryParse(widthController.text) ?? 0.0,
                              imageHeight: double.tryParse(heightController.text) ?? 0.0,
                              channel0ProteinName: channel0Name,
                              channel1ProteinName: channel1Name,
                              channel2ProteinName: channel2Name,
                              channel3ProteinName: channel3Name,
                              channel4ProteinName: channel4Name,
                              units: unitsController.text,
                            );
                            final config = ref.read(convexHullConfigProvider.notifier);
                            config.setConvexHullConfig(convexHullConfigModel: newConfig);
                            config.setLeftMenu(leftMenu: LeftMenuEnum.functionResults);
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
