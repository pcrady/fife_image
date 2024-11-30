import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/widgets/dropdown_form_menu.dart';
import 'package:fife_image/widgets/working_directory_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullSettings extends ConsumerStatefulWidget {
  const ConvexHullSettings({super.key});

  @override
  ConsumerState<ConvexHullSettings> createState() => _ConvexHullSettingsState();
}

class _ConvexHullSettingsState extends ConsumerState<ConvexHullSettings> {
  // TODO get microscope objectives for image sizing
  // TODO make config survive restart
  final _formKey = GlobalKey<FormState>();
  late TextEditingController channelNumberController;
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController unitsController;
  late TextEditingController overlayController;
  List<TextEditingController> searchPatternControllers = [];
  List<TextEditingController> proteinNameControllers = [];
  List<FocusNode> focusNodes = [];
  late FocusNode overlayFocusNode;
  List<bool> addToOverlay = [];
  List<Color> overlayColors = [];
  bool insulinAndGlucagon = true;
  static const defaultColor = Colors.white;
  List<String> imageNames = [];

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

  List<Widget> _buildMenuChildren(String searchString) {
    final subImages = imageNames.where((name) => name.contains(searchString));
    return subImages
        .map(
          (name) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name),
          ),
        )
        .toList();
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
            focusNodes.add(FocusNode(debugLabel: 'FocusNode($i)'));
            proteinNameControllers.add(TextEditingController());
            addToOverlay.add(false);
            overlayColors.add(defaultColor);
          }
        } else if (intValue < searchPatternControllers.length) {
          for (int i = searchPatternControllers.length; i > intValue; i--) {
            searchPatternControllers.removeLast();
            focusNodes.removeLast();
            proteinNameControllers.removeLast();
            addToOverlay.removeLast();
            overlayColors.removeLast();
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
        focusNodes.add(FocusNode(debugLabel: 'FocusNode($i)'));
        proteinNameControllers.add(TextEditingController(text: proteins[i]));
        addToOverlay.add(false);
        overlayColors.add(defaultColor);
      }
    } else {
      final config = convexHullConfig.searchPatternProteinConfig;
      config.forEach((searchPattern, proteinName) {
        searchPatternControllers.add(TextEditingController(text: searchPattern));
        focusNodes.add(FocusNode(debugLabel: 'FocusNode($searchPattern)'));
        proteinNameControllers.add(TextEditingController(text: proteinName));
        addToOverlay.add(convexHullConfig.searchPatternOverlayConfig[searchPattern] ?? false);
        overlayColors.add(Color(convexHullConfig.searchPatternOverlayColorConfig[searchPattern] ?? defaultColor.value));
      });
    }
    overlayFocusNode = FocusNode(debugLabel: 'FocusNode(overlay)');
    widthController = TextEditingController(text: convexHullConfig.imageWidth.toString());
    heightController = TextEditingController(text: convexHullConfig.imageHeight.toString());
    unitsController = TextEditingController(text: convexHullConfig.units.toString());
    overlayController = TextEditingController(text: convexHullConfig.overlaySearchPattern.toString());
    imageNames = ref.read(imagesProvider).value?.map((image) => image.name).toList() ?? [];
    imageNames.sort();
    imageNames
        .removeWhere((name) => name.endsWith('_bg_correct') || name.endsWith('_inflammation') || name.endsWith('_custom_infiltration'));

    ref.listenManual(imagesProvider, (previous, next) {
      imageNames = next.value?.map((image) => image.name).toList() ?? [];
      imageNames.sort();
      imageNames
          .removeWhere((name) => name.endsWith('_bg_correct') || name.endsWith('_inflammation') || name.endsWith('_custom_infiltration'));
    });
    super.initState();
  }

  @override
  void dispose() {
    final controllerNumber = searchPatternControllers.length;
    for (int i = 0; i < controllerNumber; i++) {
      searchPatternControllers[i].dispose();
      focusNodes[i].dispose();
      proteinNameControllers[i].dispose();
    }
    overlayFocusNode.dispose();
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

          return Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8.0),
                const WorkingDirectorySelector(),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                    const SizedBox(width: 8.0),
                    Expanded(
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
                    const SizedBox(width: 8.0),
                    Expanded(
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
                    const SizedBox(width: 8.0),
                    Expanded(
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
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchPatternControllers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: halfWidth,
                              child: MenuAnchor(
                                childFocusNode: focusNodes[index],
                                menuChildren: _buildMenuChildren(searchPatternControllers[index].text),
                                style: MenuStyle(
                                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                                ),
                                builder: (BuildContext context, MenuController controller, Widget? child) {
                                  return TextFormField(
                                    focusNode: focusNodes[index],
                                    onTap: () => controller.open(),
                                    onTapOutside: (_) => controller.close(),
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    validator: (_) {
                                      final searchPattern = searchPatternControllers[index].text;
                                      if (searchPattern.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      final searchPatterns = searchPatternControllers.map((controller) => controller.text).toList();
                                      searchPatterns.removeAt(index);
                                      for (var pattern in searchPatterns) {
                                        if (pattern.contains(searchPattern)) {
                                          return 'Your search pattern cannot be contained in another';
                                        }
                                      }
                                      return null;
                                    },
                                    controller: searchPatternControllers[index],
                                    decoration: InputDecoration(
                                      hintText: 'Set Channel $index Search Pattern',
                                      border: const OutlineInputBorder(),
                                      labelText: 'Channel $index Search Pattern',
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: DropdownFormMenu<String>(
                                validator: (_) {
                                  final protein = proteinNameControllers[index].text;
                                  final proteins = proteinNameControllers.map((controller) => controller.text).toList();
                                  proteins.removeAt(index);
                                  if (proteins.contains(protein)) {
                                    return 'You cannot have duplicate protein names.';
                                  }
                                  return validator(protein);
                                },
                                width: double.infinity,
                                hintText: 'Protein',
                                controller: proteinNameControllers[index],
                                entries: proteins.map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(value: value, label: value);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            if (addToOverlay[index])
                              Tooltip(
                                message: 'Color on overlay',
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: const Color(0xff101418),
                                        title: const Text('Pick A Color'),
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            paletteType: PaletteType.hueWheel,
                                            enableAlpha: false,
                                            displayThumbColor: true,
                                            portraitOnly: true,
                                            pickerColor: overlayColors[index],
                                            onColorChanged: (Color color) {
                                              setState(() {
                                                overlayColors[index] = color;
                                              });
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: const Text('Got it'),
                                            onPressed: () {
                                              //setState(() => currentColor = pickerColor);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: halfWidth * 0.1,
                                    height: 30.0,
                                    color: overlayColors[index],
                                  ),
                                ),
                              )
                            else
                              Container(),
                            SizedBox(
                              width: halfWidth * 0.1,
                              child: Tooltip(
                                message: 'Add to overlay image',
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  value: addToOverlay[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      addToOverlay[index] = !addToOverlay[index];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  },
                ),
                MenuAnchor(
                    childFocusNode: overlayFocusNode,
                    menuChildren: _buildMenuChildren(overlayController.text),
                    style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                    ),
                    builder: (BuildContext context, MenuController controller, Widget? child) {
                      return TextFormField(
                        focusNode: overlayFocusNode,
                        onTap: () => controller.open(),
                        onTapOutside: (_) => controller.close(),
                        onChanged: (_) {
                          setState(() {});
                        },
                        validator: validator,
                        controller: overlayController,
                        decoration: const InputDecoration(
                          hintText: 'Overlay Search Pattern',
                          border: OutlineInputBorder(),
                          labelText: 'Overlay Search Pattern',
                        ),
                      );
                    }),
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
                      child: Container(),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final proteins = proteinNameControllers.map((controller) => controller.text).toList();
                            if (!proteins.contains(insulin) || !proteins.contains(glucagon)) {
                              setState(() => insulinAndGlucagon = false);
                              return;
                            } else {
                              setState(() => insulinAndGlucagon = true);
                            }
                            Map<String, String> searchPatternProteinConfig = {};
                            Map<String, bool> searchPatternOverlayConfig = {};
                            Map<String, int> searchPatternOverlayColorConfig = {};

                            for (var i = 0; i < searchPatternControllers.length; i++) {
                              final searchPattern = searchPatternControllers[i].text;
                              searchPatternProteinConfig[searchPattern] = proteinNameControllers[i].text;
                              searchPatternOverlayConfig[searchPattern] = addToOverlay[i];
                              searchPatternOverlayColorConfig[searchPattern] = overlayColors[i].value;
                            }

                            final oldConvexHullConfig = ref.watch(convexHullConfigProvider);
                            final newConvexHullConfig = oldConvexHullConfig.copyWith(
                              overlaySearchPattern: overlayController.text,
                              imageHeight: double.tryParse(heightController.text) ?? 0.0,
                              imageWidth: double.tryParse(widthController.text) ?? 0.0,
                              units: unitsController.text,
                              channelNumber: int.tryParse(channelNumberController.text) ?? 0,
                              searchPatternProteinConfig: searchPatternProteinConfig,
                              searchPatternOverlayConfig: searchPatternOverlayConfig,
                              leftMenuEnum: LeftMenuEnum.functionImageSelection,
                              searchPatternOverlayColorConfig: searchPatternOverlayColorConfig,
                            );
                            try {
                              ref.read(convexHullConfigProvider.notifier).setConvexHullConfig(convexHullConfigModel: newConvexHullConfig);
                            } catch (err, stack) {
                              logger.e(err, stackTrace: stack);
                            }
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
