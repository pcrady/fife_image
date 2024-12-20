import 'dart:ui' as ui;
import 'package:cross_file/cross_file.dart';
import 'package:fife_image/lib/app_logger.dart';
import 'package:fife_image/models/abstract_image.dart';
import 'package:fife_image/providers/working_dir_provider.dart';
import 'package:fife_image/widgets/selected_image_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class SelectedImage extends ConsumerStatefulWidget {
  final AbstractImage image;

  const SelectedImage({
    required this.image,
    super.key,
  });

  @override
  ConsumerState createState() => _SelectedImageState();
}

class _SelectedImageState extends ConsumerState<SelectedImage> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final Color _color = Colors.white;

  Future<void> _saveImage() async {
    try {
      final data = await widget.image.xFile.readAsBytes();
      final ui.Image originalImage = await decodeImageFromList(data);
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..colorFilter = ColorFilter.mode(_color, BlendMode.modulate);
      canvas.drawImage(originalImage, Offset.zero, paint);
      final ui.Image filteredImage = await recorder.endRecording().toImage(
            originalImage.width,
            originalImage.height,
          );
      final ByteData? byteData = await filteredImage.toByteData(format: ui.ImageByteFormat.png);
      final directory = ref.read(workingDirProvider).value;
      if (directory == null || byteData == null) {
        return;
      }

      final filePath = '$directory/converted/filtered_image.png';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      logger.i('Filtered image saved at $filePath');
    } catch (e) {
      logger.e('Error applying filter and saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.precise,
          child: Container(
            clipBehavior: Clip.antiAlias,
            foregroundDecoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: RepaintBoundary(
              key: _repaintBoundaryKey,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(_color, BlendMode.modulate),
                child: SelectedImagePaint(image: widget.image),
              ),
            ),
          ),
        ),
        SelectableText(
          widget.image.name,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        /*TextButton(
          onPressed: () async {
            await _saveImage();
          },
          child: Text('Save'),
        ),
        ColorPicker(
          paletteType: PaletteType.hueWheel,
          enableAlpha: false,
          displayThumbColor: true,
          portraitOnly: true,
          pickerColor: _color,
          onColorChanged: (Color color) {
            setState(() {
              _color = color;
            });
          },
        ),*/
      ],
    );
  }
}
