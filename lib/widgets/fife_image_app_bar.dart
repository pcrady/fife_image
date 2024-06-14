import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
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
  late List<String> dropdownValues;
  late String dropdownValue;

  @override
  void initState() {
    dropdownValues = FunctionsEnum.values.map((element) => element.toName()).toList();
    dropdownValue = dropdownValues.first;
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
            if (result != null) {
              List<AbstractImage> images = result.files.map((file) => AbstractImage(file: file)).toList();
              ref.read(imagesProvider.notifier).setImages(images: images);
            }
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
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          style: const TextStyle(color: Colors.black),
          underline: Container(),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: dropdownValues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends ConsumerState<AppBarBottom> {
  static final _baseButtons = [const Text('Images')];
  static final _baseSelectedButtons = [true];

   List<Widget> _buttons = _baseButtons;
   List<bool> _selectedButtons = _baseSelectedButtons;

  @override
  Widget build(BuildContext context) {
    final appData = ref.read(appDataProvider);

    _buttons = List.from(_baseButtons);
    _selectedButtons = List.from(_baseSelectedButtons);

    _buttons.add(Text(appData.function.toName()));
    _selectedButtons.add(false);

    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedButtons.length; i++) {
            _selectedButtons[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.red[700],
      selectedColor: Colors.white,
      fillColor: Colors.red[200],
      color: Colors.red[400],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: _selectedButtons,
      children: _buttons,
    );
  }
}
