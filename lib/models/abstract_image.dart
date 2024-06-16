import 'package:fife_image/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class AbstractImage {
  final String? path;
  final PlatformFile? file;

  AbstractImage({
    this.path,
    this.file,
  });

  String get url => server + (path ?? '');
  String get name => basename(path ?? '').split('.').first;
  String get baseName => name.split('_').first;

  factory AbstractImage.fromJson(Map<String, dynamic> json) => AbstractImage(
        path: json['path'] as String?,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> values = {};
    if (path != null) values['path'] = path;
    if (file != null) values['file'] = file?.bytes;
    return values;
  }

  @override
  bool operator ==(Object other) {
    if (other is! AbstractImage) return false;
    if ((other.path == path) && (other.file == file)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(path, file);
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
