import 'package:dio/dio.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/app_data_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants.dart';

// flutter pub run build_runner build
part 'app_data_provider.g.dart';

@riverpod
class AppData extends _$AppData {
  final _dio = Dio();

  @override
  Future<AppDataStore> build() async {
    final response = await _dio.get(server);
    List<String> filePaths = List<String>.from(response.data);
    List<AbstractImage> images = filePaths.map((path) => AbstractImage(path: path)).toList();
    return AppDataStore(images: images);
  }

  Future<void> setImages({required List<AbstractImage> images}) async {
    final previousState = await future;
    final data = previousState.copyWith(images: images);
    List<Future> futures = [];
    for (final image in data.images ?? []) {
      futures.add(_sendImage(image: image));
    }
    await Future.wait(futures);
    ref.invalidateSelf();
  }

  void addImage({required AbstractImage image}) async {
    await _sendImage(image: image);
    ref.invalidateSelf();
  }

  Future<void> _sendImage({required AbstractImage image}) async {
    if (image.file?.bytes == null) return;
    if (image.file?.name == null) return;

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        image.file!.bytes!,
        filename: image.file!.name,
      ),
    });

    await _dio.post(
      server,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  void removeImage({required AbstractImage image}) {}

  void selectImage({required AbstractImage? image}) async {
    final previousState = await future;
    state = AsyncData(previousState.copyWith(selectedImage: image));
  }
}
