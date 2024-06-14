
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

