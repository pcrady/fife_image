import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColocalizationDialog extends ConsumerStatefulWidget {
  final List<String> proteins;
  final List<Map<String, bool>> config;
  final void Function(List<Map<String, bool>>) callback;

  const ColocalizationDialog({
    required this.proteins,
    required this.config,
    required this.callback,
    super.key,
  });

  @override
  ConsumerState createState() => _ColocalizationDialogState();
}

class _ColocalizationDialogState extends ConsumerState<ColocalizationDialog> {
  late TextEditingController controller;
  late List<Map<String, bool>> config;

  void addConfig() {
    config.add({for (var protein in widget.proteins) protein: false});
  }

  void removeConfig() {
    config.removeLast();
  }

  @override
  void initState() {
    controller = TextEditingController();
    config = List.from(widget.config);
    if (config.isEmpty) {
      addConfig();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text('Colocalization Config'),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (config.length > 1) {
                  removeConfig();
                }
              });
            },
            icon: const Icon(Icons.remove),
          ),
          Text(config.length.toString()),
          IconButton(
            onPressed: () {
              setState(() {
                addConfig();
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: const Color(0xff1f004a),
      content: SizedBox(
        width: 400.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: config.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final entries = config[index].entries.toList();

                return Column(
                  children: List<Widget>.generate(
                    entries.length,
                    (i) => CheckboxListTile(
                      value: entries[i].value,
                      title: Text(
                        entries[i].key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onChanged: (value) {
                        setState(() {
                          config[index][entries[i].key] = value ?? false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
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
          onPressed: () {
            widget.callback(config);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
