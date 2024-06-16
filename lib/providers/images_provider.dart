import 'package:dio/dio.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/models/convex_hull_state.dart';
import 'package:fife_image/models/enums.dart';
import 'package:fife_image/providers/app_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// flutter pub run build_runner build
part 'images_provider.g.dart';

@riverpod
class Images extends _$Images {
  final _dio = Dio();

  @override
  Future<List<AbstractImage>> build() async {
    final response = await _dio.get(server);
    List<String> filePaths = List<String>.from(response.data);
    return filePaths.map((path) => AbstractImage(path: path)).toList();
  }

  Future<void> setImages({required List<AbstractImage> images}) async {
    List<Future> futures = [];
    for (final image in images) {
      futures.add(_sendImage(image: image));
    }
    await Future.wait(futures);
    ref.invalidateSelf();
  }

  Future<void> addImage({required AbstractImage image}) async {
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
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<void> deleteImage({required AbstractImage image}) async {
    await _dio.post(
      '$server/delete',
      data: {'filename': image.name},
    );
    ref.invalidateSelf();
  }

  Future<void> backgroundSelect() async {
    final appData = ref.read(appDataProvider);
    final imageName = appData.selectedImage?.path;
    if (imageName == null) return;
    final convexHullState = appData.convexHullState;
    late ConvexHullState newConvexHullState;

    if (convexHullState.step == ConvexHullStep.channel1BackgroundSelect) {
       newConvexHullState = convexHullState.copyWith(step: ConvexHullStep.channel2BackgroundSelect);
    } else if (convexHullState.step == ConvexHullStep.channel2BackgroundSelect) {
       newConvexHullState = convexHullState.copyWith(step: ConvexHullStep.channel3BackgroundSelect);
    } else if (convexHullState.step == ConvexHullStep.channel3BackgroundSelect) {
      newConvexHullState = convexHullState.copyWith(step: ConvexHullStep.channel4BackgroundSelect);
    } else if (convexHullState.step == ConvexHullStep.channel4BackgroundSelect) {
      newConvexHullState = convexHullState.copyWith(step: ConvexHullStep.isletCropping);
    } else if (convexHullState.step == ConvexHullStep.isletCropping) {
      newConvexHullState = convexHullState.copyWith(step: ConvexHullStep.complete);
    } else {
      return;
    }

    await _dio.post(
      '$server/background_select',
      data: {},
    );
    ref.invalidateSelf();
  }
}
