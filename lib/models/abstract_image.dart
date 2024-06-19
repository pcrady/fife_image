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

class ConvexHullImageSet {
  String? baseName;
  AbstractImage? channel1;
  AbstractImage? channel1BackgroundCorrect;
  AbstractImage? channel2;
  AbstractImage? channel2BackgroundCorrect;
  AbstractImage? channel3;
  AbstractImage? channel3BackgroundCorrect;
  AbstractImage? channel4;
  AbstractImage? channel4BackgroundCorrect;
  AbstractImage? overlay;

  ConvexHullImageSet({
    this.baseName,
    this.channel1,
    this.channel1BackgroundCorrect,
    this.channel2,
    this.channel2BackgroundCorrect,
    this.channel3,
    this.channel3BackgroundCorrect,
    this.channel4,
    this.channel4BackgroundCorrect,
    this.overlay,
  });

  List<AbstractImage> get backgroundCorrectedImages {
    List<AbstractImage> values = [];
    if (channel1BackgroundCorrect != null) {
      values.add(channel1BackgroundCorrect!);
    }
    if (channel2BackgroundCorrect != null) {
      values.add(channel2BackgroundCorrect!);
    }
    if (channel3BackgroundCorrect != null) {
      values.add(channel3BackgroundCorrect!);
    }
    if (channel4BackgroundCorrect != null) {
      values.add(channel4BackgroundCorrect!);
    }
    return values;
  }

  List<AbstractImage> get unmodifiedImages {
    List<AbstractImage> values = [];
    if (channel1 != null) {
      values.add(channel1!);
    }
    if (channel2 != null) {
      values.add(channel2!);
    }
    if (channel3 != null) {
      values.add(channel3!);
    }
    if (channel4 != null) {
      values.add(channel4!);
    }
    return values;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConvexHullImageSet) return false;
    return other.baseName == baseName &&
        other.channel1 == channel1 &&
        other.channel1BackgroundCorrect == channel1BackgroundCorrect &&
        other.channel2 == channel2 &&
        other.channel2BackgroundCorrect == channel2BackgroundCorrect &&
        other.channel3 == channel3 &&
        other.channel3BackgroundCorrect == channel3BackgroundCorrect &&
        other.channel4 == channel4 &&
        other.channel4BackgroundCorrect == channel4BackgroundCorrect &&
        other.overlay == overlay;
  }

  @override
  int get hashCode => Object.hash(
        baseName,
        channel1,
        channel1BackgroundCorrect,
        channel2,
        channel2BackgroundCorrect,
        channel3,
        channel3BackgroundCorrect,
        channel4,
        channel4BackgroundCorrect,
        overlay,
      );
}
