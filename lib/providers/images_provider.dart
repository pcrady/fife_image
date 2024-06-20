import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'images_provider.g.dart';

@riverpod
class Images extends _$Images {
  final _dio = Dio();

  @override
  Future<List<AbstractImage>> build() async {
    final response = await _dio.get(server);
    final data = List<Map<String, dynamic>>.from(response.data);
    var images = data.map((fileData) => AbstractImage.fromJson(fileData)).toList();
    images.sort((a, b) => a.imagePath.compareTo(b.imagePath));
    return images;
  }

  Future<void> uploadImages({
    required FilePickerResult? filePickerResult,
  }) async {
    if (filePickerResult == null) return;
    List<AbstractImage> images = [];

    for (final file in filePickerResult.files) {
      images.add(
        AbstractImage(
          imagePath: file.name,
          file: file.bytes,
        ),
      );
    }

    List<Future> futures = [];
    for (final image in images) {
      futures.add(_uploadImage(image: image));
    }
    await Future.wait(futures);
    ref.invalidateSelf();
  }

  Future<void> _uploadImage({
    required AbstractImage image,
  }) async {
    final bytes = image.file;
    if (bytes == null) return;
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        bytes,
        filename: image.imagePath,
      ),
    });
    await _dio.post(
      server,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteImageFromServer({
    required AbstractImage image,
  }) async {
    await _dio.post(
      '$server/delete',
      data: {'filename': image.name},
    );
    ref.invalidateSelf();
  }

  Future<void> updateSelection({
    required AbstractImage image,
    required List<Offset>? selection,
  }) async {
    final images = await future;
    images.remove(image);
    final newImage = image.copyWith(relativeSelectionCoordinates: selection);
    images.add(newImage);
    images.sort((a, b) => a.imagePath.compareTo(b.imagePath));
    ref.read(appDataProvider.notifier).selectImage(image: newImage);
    ref.notifyListeners();
  }
}
