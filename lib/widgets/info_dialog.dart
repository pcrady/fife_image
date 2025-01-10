import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoDialog extends ConsumerStatefulWidget {
  final String appVersion;
  final String serverVersion;
  final String appLogFile;
  final String serverLogFile;

  const InfoDialog({
    required this.appVersion,
    required this.serverVersion,
    required this.appLogFile,
    required this.serverLogFile,
    super.key,
  });

  @override
  ConsumerState createState() => _InfoDialogState();
}


class _InfoDialogState extends ConsumerState<InfoDialog> {
  late String selectedFilePath;
  List<String> logFileContents = [];
  late final StreamController<String> _logStreamController;
  late final ScrollController scrollController;
  bool serverLog = true;

  @override
  void initState() {
    super.initState();
    selectedFilePath = widget.serverLogFile;
    scrollController = ScrollController();
    _logStreamController = StreamController();
    _startReadingFile();
  }

  void _startReadingFile() async {
    final file = File(selectedFilePath);

    if (await file.exists()) {
      final stream = file.openRead();
      try {
        await for (final line in stream.transform(utf8.decoder).transform(const LineSplitter())) {
          _logStreamController.add(line);
          logFileContents.add(line);
        }
        logFileContents = logFileContents.reversed.toList();
      } catch (e) {
        _logStreamController.addError("Error reading file: $e");
        _logStreamController.close();
      }
    } else {
      _logStreamController.addError("File does not exist.");
      _logStreamController.close();
    }
  }

  @override
  void dispose() {
    _logStreamController.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Basic Info: ${serverLog ? 'Server Log' : 'App Log'}'),
      backgroundColor: const Color(0xff1f004a),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Version: ${widget.appVersion}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Server Version: ${widget.serverVersion}',
              style: const TextStyle(color: Colors.white),
            ),
            const Divider(),
            StreamBuilder<String>(
              stream: _logStreamController.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  return const Text('No data');
                }

                return SizedBox(
                  height: 700,
                  child: RawScrollbar(
                    thumbColor: Colors.white30,
                    radius: const Radius.circular(20),
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: logFileContents.length,
                      itemBuilder: (context, index) {
                        return Text(
                          logFileContents[index],
                          style: const TextStyle(color: Colors.white),
                        );
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
          onPressed: () {
            setState(() {
              serverLog = false;
              logFileContents = [];
              selectedFilePath = widget.appLogFile;
              _startReadingFile();
            });
          },
          child: const Text('View App Log'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              serverLog = true;
              logFileContents = [];
              selectedFilePath = widget.serverLogFile;
              _startReadingFile();
            });
          },
          child: const Text('View Server Log'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
