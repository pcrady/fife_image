import 'dart:typed_data';
import 'dart:ui';
import 'package:fife_image/constants.dart';
import 'package:fife_image/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';

part 'abstract_image.freezed.dart';
part 'abstract_image.g.dart';


@freezed
class AbstractImage with _$AbstractImage {
  const AbstractImage._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory AbstractImage({
    String? imagePath,
    String? md5Hash,
    @Uint8ListConverter() Uint8List? file,
    @OffsetListConverter() List<Offset>? relativeSelectionCoordinates,
  }) = _AbstractImage;

  String get url => server + (imagePath ?? '');
  String get name => basename(imagePath ?? '').split('.').first;
  String get baseName => name.split('_').first;

  factory AbstractImage.fromJson(Map<String, dynamic> json) => _$AbstractImageFromJson(json);
}
