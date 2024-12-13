import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cross_file/cross_file.dart';
import 'package:fife_image/constants.dart';
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
    String? md5Hash,
    @OffsetListConverter() List<Offset>? relativeSelectionCoordinates,
  }) = _AbstractImage;

  String get imagePath => fileImage.file.path;
  String get url => server + imagePath;
  String get name => basename(imagePath).split('.').first;
  String get baseName => name.split('_').first;
  bool get isBackgroundCorrected => name.contains('bg_correct');
  XFile get xFile => XFile(imagePath);
  Future<Uint8List> get file async => await fileImage.file.readAsBytes();

  Future<bool> evict() async => await fileImage.evict();

  factory AbstractImage.fromJson(Map<String, dynamic> json) => _$AbstractImageFromJson(json);
}
