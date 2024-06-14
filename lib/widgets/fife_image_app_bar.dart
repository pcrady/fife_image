import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
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
              ref.read(appDataProvider.notifier).setImages(images: images);
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
    );
  }
}
