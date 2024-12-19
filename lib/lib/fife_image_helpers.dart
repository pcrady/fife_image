import 'package:dio/dio.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:flutter/material.dart';

mixin FifeImageHelpers {
  fifeImageSnackBar({
    required BuildContext context,
    required String message,
    Object? err,
    DioException? dioErr,
    StackTrace? stack,
  }) {
    logger.e(dioErr ?? err, stackTrace: stack);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 10),
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 16.0),
          Text('Error: $message'),
        ],
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
