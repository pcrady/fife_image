import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FifeImageAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const FifeImageAppBar({
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
    final loading = ref.watch(appDataProvider).loading;

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading ? const CircularProgressIndicator() : Container(),
          const SizedBox(width: 16.0),
          const Text(
            'Fife Image',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () async {
          try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
            ref.read(appDataProvider.notifier).setLoadingTrue();
            await ref.read(imagesProvider.notifier).uploadImages(filePickerResult: result);
          } catch (err, stack) {
            ref.read(appDataProvider.notifier).setLoadingFalse();
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
          dropdownColor: Colors.black54,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
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
                    color: Colors.white,
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