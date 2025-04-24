import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../lib/app_logger.dart';

// flutter pub run build_runner build
part 'images_provider.g.dart';

@riverpod
class Images extends _$Images {
  final _dio = Dio();

  // TODO this does not work
  /*List<AbstractImage>? _previousState;
  Future<void> _evict(
    List<AbstractImage>? newImages,
    List<AbstractImage>? previousImages,
  ) async {
    if (newImages == null || previousImages == null) return;
    for (AbstractImage image in previousImages) {
      if (!newImages.contains(image)) {
        await image.evict();
      }
    }
  }*/

  @override
  Future<List<AbstractImage>> build() async {
    ref.watch(workingDirProvider);
    final response = await _dio.get(server);
    final data = List<Map<String, dynamic>>.from(response.data);
    var images = data.map((fileData) => AbstractImage.fromJson(fileData)).toList();
    images.sort((a, b) => a.imagePath.compareTo(b.imagePath));
    ref.read(appDataProvider.notifier).setLoadingFalse();
    imageCache.clear();
    imageCache.clearLiveImages();
    return images;
  }

  Future<void> uploadImages({
    required FilePickerResult? filePickerResult,
  }) async {
    if (filePickerResult == null) return;
    List<AbstractImage> images = [];

    for (final file in filePickerResult.files) {
      final path = file.path;
      if (path == null) continue;
      final fileImage = FileImage(File(path));
      images.add(AbstractImage(fileImage: fileImage));
    }

    List<Future> futures = [];
    const batchSize = 50;
    for (int i = 0; i < images.length; i++) {
      futures.add(_uploadImage(image: images[i]));
      if (i != 0 && i.remainder(batchSize) == 0) {
        await Future.wait(futures);
        futures = [];
      }
    }
    await Future.wait(futures);
    ref.invalidateSelf();
  }

  Future<void> _uploadImage({
    required AbstractImage image,
  }) async {
    final bytes = await image.file;
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
        validateStatus: (status) {
          return (status ?? 400) < 400;
        },
      ),
    );
  }

  Future<void> deleteImageFromServer({
    required AbstractImage image,
    required ConvexHullConfigModel convexHullConfig,
  }) async {
    await _dio.post(
      '$server/delete',
      data: {
        'filename': image.name,
        'basename': image.baseName(convexHullConfig),
      },
    );

    final appData = ref.read(appDataProvider);
    final hullResults = appData.activeResults;
    final imagePath = appData.selectedImage?.imagePath;
    if (imagePath == image.imagePath) {
      ref.read(appDataProvider.notifier).selectImage(image: null);
    }

    if (image.imagePath == hullResults?.simplex?.imagePath ||
        image.imagePath == hullResults?.infiltration?.imagePath ||
        image.imagePath == hullResults?.inflammation?.imagePath) {
      ref.read(appDataProvider.notifier).setActiveResults(results: null);
    }
    final previousState = await future;
    previousState.remove(image);
    state = AsyncData(previousState);
  }

  Future<void> updateSelection({
    required AbstractImage image,
    required List<Offset>? selection,
  }) async {
    final images = await future;
    images.removeWhere((oldImage) => oldImage.imagePath == image.imagePath);
    final newImage = image.copyWith(relativeSelectionCoordinates: selection);
    images.add(newImage);
    images.sort((a, b) => a.imagePath.compareTo(b.imagePath));
    ref.read(appDataProvider.notifier).selectImage(image: newImage);
    ref.notifyListeners();
  }
}
