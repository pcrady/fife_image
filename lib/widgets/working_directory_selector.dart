import 'package:fife_image/functions/convex_hull/widgets/convex_hull_image_selector.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkingDirectorySelector extends ConsumerStatefulWidget {
  const WorkingDirectorySelector({super.key});

  @override
  ConsumerState createState() => _WorkingDirectorySelectorState();
}

class _WorkingDirectorySelectorState extends ConsumerState<WorkingDirectorySelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final dir = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select where you want to save all the files.',
            );
            try {
              await ref.read(workingDirProvider.notifier).setWorkingDir(workingDir: dir);
            } catch (err, stack) {
              logger.e(err, stackTrace: stack);
            }
          },
          child: const Text('Select Working Directory'),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: ScrollConfiguration(
            behavior: DraggableScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                ref.watch(workingDirProvider).when(
                      data: (data) => data ?? '',
                      error: (_, __) => '',
                      loading: () => '',
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
