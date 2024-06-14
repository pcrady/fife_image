import 'package:file_picker/file_picker.dart';

class AbstractImage {
  final String? url;
  final PlatformFile? file;

  AbstractImage({
    this.url,
    this.file,
  });

  factory AbstractImage.fromJson(Map<String, dynamic> json) => AbstractImage(
        url: json['url'] as String?,
      );

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> values = {};
    if (url != null) values['url'] = url;
    if (file != null) values['file'] = await file!.xFile.readAsBytes();
    return values;
  }

  @override
  bool operator ==(Object other) {
    if (other is! AbstractImage) return false;
    if ((other.url == url) && (other.file == file)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(url, file);

}

