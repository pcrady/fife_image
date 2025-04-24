import 'package:dio/dio.dart';
import 'package:fife_image/lib/fife_image_functions.dart';
import 'package:fife_image/lib/fife_image_helpers.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/app_info_provider.dart';
import 'package:fife_image/providers/heartbeat_provider.dart';
import 'package:fife_image/providers/images_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:fife_image/widgets/info_dialog.dart';
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

class _FifeImageAppBarState extends ConsumerState<FifeImageAppBar> with FifeImageHelpers {
  late List<FunctionsEnum> dropdownValues;
  late FunctionsEnum dropdownValue;

  Future<void> _dialogBuilder(BuildContext context) async {
    final value = await ref.read(appInfoProvider.future);
    final appLogFile = ref.read(workingDirProvider.notifier).appLogFile;
    final serverLogFile = ref.read(workingDirProvider.notifier).serverLogFile;

    if (!context.mounted) return;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(
          appVersion: value.appVersion,
          serverVersion: value.serverVersion,
          appLogFile: appLogFile!,
          serverLogFile: serverLogFile!,
        );
      },
    );
  }

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
          TextButton(
            onPressed: () async {
              await _dialogBuilder(context);
            },
            child: const Text(
              'Fife Image',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () async {
          try {
            ref.read(appDataProvider.notifier).setLoadingTrue();
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              withData: false,
            );
            if (result == null) return;
            await ref.read(imagesProvider.notifier).uploadImages(filePickerResult: result);
            if (!context.mounted) return;
          } on DioException catch (err, stack) {
            fifeImageSnackBar(
              context: context,
              message: err.response?.data.toString() ?? 'An error has occurred',
              dioErr: err,
              stack: stack,
            );
          } catch (err, stack) {
            fifeImageSnackBar(
              context: context,
              message: err.toString(),
              err: err,
              stack: stack,
            );
          } finally {
            ref.read(appDataProvider.notifier).setLoadingFalse();
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
            return DropdownMenuItem<FunctionsEnum>(
              value: function,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  function.name,
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
