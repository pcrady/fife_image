import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FifeImageAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  const FifeImageAppBar({
    this.bottom,
    super.key,
  });

  @override
  ConsumerState<FifeImageAppBar> createState() => _FifeImageAppBarState();
}

class _FifeImageAppBarState extends ConsumerState<FifeImageAppBar> {
  late List<FunctionsEnum> dropdownValues;
  late FunctionsEnum dropdownValue;

  @override
  void initState() {
    dropdownValues = FunctionsEnum.values;
    dropdownValue = FunctionsEnum.values.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Fife Image',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        onPressed: () async {
          try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
            await ref.read(imagesProvider.notifier).uploadImages(filePickerResult: result);
          } catch (err, stack) {
            logger.e(err, stackTrace: stack);
          }
        },
        icon: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
      actions: [
        DropdownButton<FunctionsEnum>(
          value: dropdownValue,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          style: const TextStyle(color: Colors.black),
          underline: Container(),
          onChanged: (FunctionsEnum? value) {
            setState(() => dropdownValue = value!);
            ref.read(appDataProvider.notifier).setFunction(function: value!);
          },
          items: dropdownValues.map<DropdownMenuItem<FunctionsEnum>>((FunctionsEnum function) {
            final value = function.toName();
            return DropdownMenuItem<FunctionsEnum>(
              value: function,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
      bottom: widget.bottom,
    );
  }
}

class AppBarBottom extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  ConsumerState<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends ConsumerState<AppBarBottom> {
  static const _imagesValue = 'Images';
  static const _settingsValue = 'Function Settings';
  static const _resultsValue = 'Function Results';

  Set<String> _segmentedButtonSelection = {_imagesValue};

  @override
  Widget build(BuildContext context) {
    final appData = ref.watch(appDataProvider);

    if (appData.function == FunctionsEnum.functions) {
      return Container();
    } else {
      final menuSetting = ref.read(appDataProvider).leftMenu;
      if (menuSetting == LeftMenuEnum.images) {
        _segmentedButtonSelection = {_imagesValue};
      } else if (menuSetting == LeftMenuEnum.functionSettings) {
        _segmentedButtonSelection = {_settingsValue};
      } else if (menuSetting == LeftMenuEnum.functionResults) {
        _segmentedButtonSelection = {_resultsValue};
      }

      return Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SegmentedButton<String>(
                  showSelectedIcon: true,
                  selected: _segmentedButtonSelection,
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => _segmentedButtonSelection = newSelection);
                    final appData = ref.read(appDataProvider.notifier);
                    if (newSelection.first == 'Images') {
                      appData.setMenuSetting(leftMenu: LeftMenuEnum.images);
                    } else if (newSelection.first == 'Function Settings') {
                      appData.setMenuSetting(leftMenu: LeftMenuEnum.functionSettings);
                    } else if (newSelection.first == 'Function Results') {
                      appData.setMenuSetting(leftMenu: LeftMenuEnum.functionResults);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.lightBlueAccent; // Lighter blue for selected button
                        }
                        return Colors.blue; // Blue for unselected button
                      },
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Text color
                  ),
                  segments: [
                    const ButtonSegment<String>(
                      value: _imagesValue,
                      label: Text('Images'),
                    ),
                    ButtonSegment(
                      value: _settingsValue,
                      label: Text(
                        '${appData.function.toName()} Settings',
                      ),
                    ),
                    ButtonSegment(
                      value: _resultsValue,
                      label: Text(
                        '${appData.function.toName()} Results',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 30,
              ),
            ),
          ],
        ),
      );
    }
  }
}
