import 'dart:io';
import 'package:fife_image/lib/app_logger.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart';


class _ImageManipulation {
  static String _addChannelToName({
    required String fileName,
    required int channel,
  }) {
    final splitName = fileName.split('.');
    return '${splitName.first}_channel$channel.png'.replaceAll(' ', '_');
  }

  static Future<void> convertFileToPng(PlatformFile file) async {
    if (file.bytes == null) return;
    final uint8Bytes = file.bytes!;
    final bytes = uint8Bytes.toList();
    final format = findFormatForData(bytes);

    // TODO fix this
    // https://stackoverflow.com/questions/68633947/flutter-folder-picker
    const outputPath = '/Users/petercrady/StudioProjects/fife_image/server/converted';

    if (format == ImageFormat.png) {
      final outputFile = File('$outputPath/${file.name}');
      await outputFile.writeAsBytes(bytes);
    } else if (format == ImageFormat.tiff) {
      final tiffDecoder = TiffDecoder();
      final tiffInfo = tiffDecoder.startDecode(uint8Bytes)!;

      for (int frame = 0; frame < tiffInfo.numFrames; frame++) {
        Image? image = tiffDecoder.decodeFrame(frame);
        if (image == null) continue;
        // TODO need to figure out how to handle tifs with multiple channels and stuff
        // I think it will just be write each frame and then let people do whatever
        logger.i('tiff frame: $frame');
        logger.i('frames: ${image.numFrames}');
        logger.i('channels: ${image.numChannels}');
        logger.wtf(image.exif.imageIfd.data);
        //logger.i(image.frames.first.frames.first.frames.first.frames.first.numFrames);
        logger.w('------------------------------');

        final pngBytes = encodePng(image);
        final outputName = _addChannelToName(fileName: file.name, channel: frame);
        final outputFile = File('$outputPath/$outputName');
        await outputFile.writeAsBytes(pngBytes);
      }
    }
  }
}