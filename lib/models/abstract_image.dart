import 'dart:ui';

import 'package:fife_image/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class AbstractImage {
  final String? filePath;
  final PlatformFile? file;
  List<Offset>? relativeSelectionCoordinates;

  AbstractImage({
    this.filePath,
    this.file,
    this.relativeSelectionCoordinates,
  });

  String get url => server + (filePath ?? '');
  String get name => basename(filePath ?? '').split('.').first;
  String get baseName => name.split('_').first;

  List<List<double>> get selectionRegionPython {
    List<List<double>> relativeSelectionRegionList = [];
    for (Offset offset in relativeSelectionCoordinates ?? []) {
      final point = [offset.dx, offset.dy];
      relativeSelectionRegionList.add(point);
    }
    return relativeSelectionRegionList;
  }

  factory AbstractImage.fromJson(Map<String, dynamic> json) => AbstractImage(
        filePath: json['path'] as String?,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> values = {};
    if (filePath != null) values['path'] = filePath;
    if (file != null) values['file'] = file?.bytes;
    return values;
  }

  @override
  bool operator ==(Object other) {
    if (other is! AbstractImage) return false;
    if ((other.filePath == filePath) && (other.file == file)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(filePath, file);
}

class ImageSet {
  String? baseName;
  AbstractImage? channel1;
  AbstractImage? channel2;
  AbstractImage? channel3;
  AbstractImage? channel4;
  AbstractImage? overlay;

  ImageSet({
    this.baseName,
    this.channel1,
    this.channel2,
    this.channel3,
    this.channel4,
    this.overlay,
  });

  @override
  bool operator ==(Object other) {
    if (other is! ImageSet) return false;
    if ((other.baseName == baseName) &&
        (other.channel1 == channel1) &&
        (other.channel2 == channel2) &&
        (other.channel3 == channel3) &&
        (other.channel4 == channel4)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        baseName,
        channel1,
        channel2,
        channel3,
        channel4,
      );
}
