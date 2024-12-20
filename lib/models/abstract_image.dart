import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:fife_image/constants.dart';
import 'package:fife_image/functions/convex_hull/models/convex_hull_config_model.dart';
import 'package:fife_image/models/json_converters.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';

part 'abstract_image.freezed.dart';
part 'abstract_image.g.dart';

@freezed
class AbstractImage with _$AbstractImage {
  const AbstractImage._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
  const factory AbstractImage({
    @FileImageConverter() required FileImage fileImage,
    @NullableFileImageConverter() FileImage? thumbnail,
    @OffsetListConverter() List<Offset>? relativeSelectionCoordinates,
  }) = _AbstractImage;

  String get imagePath => fileImage.file.path;
  String get url => server + imagePath;
  String get name => basename(imagePath).split('.').first;

  // TODO this is sketchy
  String baseName(ConvexHullConfigModel model) {
    var trimmedName = name;
    for (final key in model.searchPatternProteinConfig.keys) {
      trimmedName = trimmedName.replaceAll(key, '').trim();
    }
    trimmedName = trimmedName.replaceAll(model.overlaySearchPattern, '').trim();
    for (final tag in tags) {
      trimmedName = trimmedName.replaceAll(tag, '').trim();
    }
    // Remove all trailing underscores
    while (trimmedName.endsWith('_')) {
      trimmedName = trimmedName.substring(0, trimmedName.length - 1);
    }
    return trimmedName;
  }

  bool get isBackgroundCorrected => name.contains('bg_correct');
  XFile get xFile => XFile(imagePath);

  Future<Uint8List> get file async => await fileImage.file.readAsBytes();

  // TODO this does not work
  Future<bool> evict() async {
    final large = await fileImage.evict();
    var small = true;
    if (thumbnail != null) {
      small = await thumbnail!.evict();
    }
    return large && small;
  }

  factory AbstractImage.fromJson(Map<String, dynamic> json) => _$AbstractImageFromJson(json);
}
