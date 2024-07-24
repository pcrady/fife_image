import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullSettings extends ConsumerStatefulWidget {
  const ConvexHullSettings({super.key});

  @override
  ConsumerState<ConvexHullSettings> createState() => _ConvexHullSettingsState();
}

class _ConvexHullSettingsState extends ConsumerState<ConvexHullSettings> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController channelNumberController;
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController unitsController;
  late TextEditingController overlayController;
  List<TextEditingController> searchPatternControllers = [];
  List<TextEditingController> proteinNameControllers = [];
  bool insulinAndGlucagon = true;
  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String generateDefaultSearchString(int i) {
    if (i < 10) {
      return 'ch0$i';
    } else {
      return 'ch$i';
    }
  }

  void listener() {
    final value = channelNumberController.text;
    if (value.isNotEmpty || (int.tryParse(value) != null)) {
      var intValue = int.tryParse(value) ?? 1;
      if (intValue > 30) {
        intValue = 30;
        channelNumberController.text = '30';
      } else if (intValue < 1) {
        intValue = 1;
        channelNumberController.text = '1';
      }
      setState(() {
        if (intValue > searchPatternControllers.length) {
          for (int i = searchPatternControllers.length; i < intValue; i++) {
            searchPatternControllers.add(TextEditingController(text: generateDefaultSearchString(i)));
            proteinNameControllers.add(TextEditingController());
          }
        } else if (intValue < searchPatternControllers.length) {
          for (int i = searchPatternControllers.length; i > intValue; i--) {
            searchPatternControllers.removeLast();
            proteinNameControllers.removeLast();
          }
        }
      });
    }
  }

  @override
  void initState() {
    final convexHullConfig = ref.read(convexHullConfigProvider);
    channelNumberController = TextEditingController(text: convexHullConfig.channelNumber.toString());
    channelNumberController.addListener(listener);
    if (convexHullConfig.searchPatternProteinConfig.isEmpty) {
      for (int i = 0; i < convexHullConfig.channelNumber; i++) {
        searchPatternControllers.add(TextEditingController(text: generateDefaultSearchString(i)));
        proteinNameControllers.add(TextEditingController(text: proteins[i]));
      }
    } else {
      final config = convexHullConfig.searchPatternProteinConfig;
      config.forEach((searchPattern, proteinName) {
        searchPatternControllers.add(TextEditingController(text: searchPattern));
        proteinNameControllers.add(TextEditingController(text: proteinName));
      });
    }
    widthController = TextEditingController(text: convexHullConfig.imageWidth.toString());
    heightController = TextEditingController(text: convexHullConfig.imageHeight.toString());
    unitsController = TextEditingController(text: convexHullConfig.units.toString());
    overlayController = TextEditingController(text: convexHullConfig.overlaySearchPattern.toString());
    super.initState();
  }

  @override
  void dispose() {
    final controllerNumber = searchPatternControllers.length;
    for (int i = 0; i < controllerNumber; i++) {
      searchPatternControllers[i].dispose();
      proteinNameControllers[i].dispose();
    }
    channelNumberController.dispose();
    widthController.dispose();
    heightController.dispose();
    unitsController.dispose();
    overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final halfWidth = constraints.maxWidth / 2.0 - 4.0;
          final fourthWidth = constraints.maxWidth / 4.0 - 4.0;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: fourthWidth,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty || (int.tryParse(value) == null)) {
                            return 'Please enter an integer value';
                          }
                          return null;
                        },
                        controller: channelNumberController,
                        decoration: const InputDecoration(
                          hintText: 'Total Number of Channels',
                          border: OutlineInputBorder(),
                          labelText: 'Total Channels',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: fourthWidth,
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
                      width: fourthWidth,
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
                      width: fourthWidth,
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchPatternControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: halfWidth,
                              child: TextFormField(
                                validator: validator,
                                controller: searchPatternControllers[index],
                                decoration: InputDecoration(
                                  hintText: 'Set Channel $index Search Pattern',
                                  border: const OutlineInputBorder(),
                                  labelText: 'Channel $index Search Pattern',
                                ),
                              ),
                            ),
                            DropdownMenu<String>(
                              width: halfWidth,
                              hintText: 'Protein',
                              controller: proteinNameControllers[index],
                              dropdownMenuEntries: proteins.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(value: value, label: value);
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    );
                  },
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
                insulinAndGlucagon
                    ? Container()
                    : const Column(
                        children: [
                          SizedBox(height: 8.0),
                          Text(
                            'You must have Insulin and Glucagon',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final proteins = proteinNameControllers.map((controller) => controller.text).toList();
                            if (!proteins.contains(insulin) || !proteins.contains(glucagon)) {
                              setState(() => insulinAndGlucagon = false);
                              return;
                            } else {
                              setState(() => insulinAndGlucagon = true);
                            }
                            Map<String, String> searchPatternProteinConfig = {};
                            for (var i = 0; i < searchPatternControllers.length; i++) {
                              searchPatternProteinConfig[searchPatternControllers[i].text] = proteinNameControllers[i].text;
                            }

                            final oldConvexHullConfig = ref.watch(convexHullConfigProvider);
                            final newConvexHullConfig = oldConvexHullConfig.copyWith(
                              overlaySearchPattern: overlayController.text,
                              imageHeight: double.tryParse(heightController.text) ?? 0.0,
                              imageWidth: double.tryParse(widthController.text) ?? 0.0,
                              units: unitsController.text,
                              channelNumber: int.tryParse(channelNumberController.text) ?? 0,
                              searchPatternProteinConfig: searchPatternProteinConfig,
                              leftMenuEnum: LeftMenuEnum.functionResults,
                            );

                            ref.read(convexHullConfigProvider.notifier).setConvexHullConfig(convexHullConfigModel: newConvexHullConfig);
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
