import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
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
    return data.map((fileData) => AbstractImage.fromJson(fileData)).toList();
  }

  Future<void> setImages({required List<AbstractImage> images}) async {
    List<Future> futures = [];
    for (final image in images) {
      futures.add(addImage(image: image));
    }
    await Future.wait(futures);
    ref.invalidateSelf();
  }

  Future<void> addImage({required AbstractImage image}) async {
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
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> deleteImage({required AbstractImage image}) async {
    await _dio.post(
      '$server/delete',
      data: {'filename': image.name},
    );
    ref.invalidateSelf();
  }
}
