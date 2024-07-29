import 'package:fife_image/functions/convex_hull/providers/convex_hull_config_provider.dart';
import 'package:fife_image/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConvexHullTopButtons extends ConsumerStatefulWidget {
  const ConvexHullTopButtons({super.key});

  @override
  ConsumerState createState() => _ConvexHullTopButtonsState();
}

class _ConvexHullTopButtonsState extends ConsumerState<ConvexHullTopButtons> {
  static const _settingsValue = 'Function Settings';
  static const _imageSelector = 'Image Selector';

  Set<String> _segmentedButtonSelection = {_settingsValue};

  @override
  Widget build(BuildContext context) {
    final convexHullConfig = ref.watch(convexHullConfigProvider);

    final menuSetting = convexHullConfig.leftMenuEnum;
    if (menuSetting == LeftMenuEnum.functionSettings) {
      _segmentedButtonSelection = {_settingsValue};
    } else if (menuSetting == LeftMenuEnum.functionImageSelection) {
      _segmentedButtonSelection = {_imageSelector};
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: SegmentedButton<String>(
            showSelectedIcon: true,
            selected: _segmentedButtonSelection,
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => _segmentedButtonSelection = newSelection);
              final config = ref.read(convexHullConfigProvider.notifier);
              if (newSelection.first == _settingsValue) {
                config.setLeftMenu(leftMenu: LeftMenuEnum.functionSettings);
              } else if (newSelection.first == _imageSelector) {
                config.setLeftMenu(leftMenu: LeftMenuEnum.functionImageSelection);
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
            segments: const [
              ButtonSegment(
                value: _settingsValue,
                label: Text('Convex Hull Settings'),
              ),
              ButtonSegment(
                value: _imageSelector,
                label: Text('Image Selector'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
