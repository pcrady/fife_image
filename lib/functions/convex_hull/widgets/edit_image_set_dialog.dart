import 'package:fife_image/functions/convex_hull/models/convex_hull_image_set.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/functions/convex_hull/providers/convex_hull_image_provider.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditImageSetDialog extends ConsumerStatefulWidget {
  final ConvexHullImageSet imageSet;

  const EditImageSetDialog({
    required this.imageSet,
    super.key,
  });

  @override
  ConsumerState createState() => _EditImageSetDialogState();
}

enum DialogState { none, copy, rename }

class _EditImageSetDialogState extends ConsumerState<EditImageSetDialog> {
  late TextEditingController nameController;
  late TextEditingController copyController;
  DialogState dialogState = DialogState.none;
  late final String? oldBaseName;

  @override
  void initState() {
    final convexHullConfig = ref.read(convexHullConfigProvider);
    nameController = TextEditingController(text: widget.imageSet.baseName(convexHullConfig));
    copyController = TextEditingController(text: '${widget.imageSet.baseName(convexHullConfig)}_copy');
    oldBaseName = widget.imageSet.baseName(convexHullConfig);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> content;
    late Widget dialogTitle;

    switch (dialogState) {
      case DialogState.none:
        dialogTitle = const Text('Edit Image Set');
        break;
      case DialogState.rename:
        dialogTitle = const Text('Rename Image Set');
        break;
      case DialogState.copy:
        dialogTitle = const Text('Create New Copy of Image Set');
        break;
    }

    switch (dialogState) {
      case DialogState.none:
        content = [
          ListTile(
            title: const Text(
              'Rename',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onTap: () {
              setState(() {
                dialogState = DialogState.rename;
              });
            },
          ),
          ListTile(
            title: const Text(
              'Copy',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.copy,
              color: Colors.white,
            ),
            onTap: () {
              setState(() {
                dialogState = DialogState.copy;
              });
            },
          ),
        ];
        break;
      case DialogState.rename:
        content = [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Image Set Name',
              border: OutlineInputBorder(),
              labelText: 'Image Set Name',
            ),
          ),
        ];
        break;
      case DialogState.copy:
        content = [
          TextFormField(
            controller: copyController,
            decoration: const InputDecoration(
              hintText: 'New Image Set Name',
              border: OutlineInputBorder(),
              labelText: 'New Image Set name',
            ),
          ),
        ];
        break;
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          dialogTitle,
          dialogState != DialogState.none
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      dialogState = DialogState.none;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : Container(),
        ],
      ),
      backgroundColor: const Color(0xff1f004a),
      content: SizedBox(
        width: 500.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Save'),
          onPressed: () async {
            try {
              final convexHullSets = ref.read(convexHullImageSetsProvider.notifier);
              if (dialogState == DialogState.copy) {
                await convexHullSets.copyImageSet(
                  imageSet: widget.imageSet,
                  newName: copyController.text,
                  oldName: oldBaseName ?? 'ERROR',
                );
              } else if (dialogState == DialogState.rename) {
                await convexHullSets.renameImageSet(
                  imageSet: widget.imageSet,
                  newName: nameController.text,
                  oldName: oldBaseName ?? 'ERROR',
                );
              }
              if (!context.mounted) return;
              Navigator.of(context).pop();
            } catch (err, stack) {
              logger.e(err, stackTrace: stack);
            }
          },
        ),
      ],
    );
  }
}
