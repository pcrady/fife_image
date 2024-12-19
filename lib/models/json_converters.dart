import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List<int>?> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List<int>? json) {
    return json == null ? null : Uint8List.fromList(json);
  }

  @override
  List<int>? toJson(Uint8List? object) {
    return object?.toList();
  }
}


class FileImageConverter implements JsonConverter<FileImage, String> {
  const FileImageConverter();

  @override
  FileImage fromJson(String json) {
    return FileImage(File(json));
  }

  @override
  String toJson(FileImage object) {
    return object.file.path;
  }
}


class NullableFileImageConverter implements JsonConverter<FileImage?, String?> {
  const NullableFileImageConverter();

  @override
  FileImage? fromJson(String? json) {
    if (json == null) return null;
    return FileImage(File(json));
  }

  @override
  String? toJson(FileImage? object) {
    if (object == null) return null;
    return object.file.path;
  }
}


class OffsetListConverter implements JsonConverter<List<Offset>?, List<List<double>>?> {
  const OffsetListConverter();

  @override
  List<Offset>? fromJson(List<List<double>>? json) {
    if (json == null) {
      return null;
    } else {
      List<Offset> relativeSelectionRegionList = [];
      for (List<double> point in json) {
        final offset = Offset(point[0], point[1]);
        relativeSelectionRegionList.add(offset);
      }
      return relativeSelectionRegionList;
    }
  }

  @override
  List<List<double>>? toJson(List<Offset>? object) {
    if (object == null) {
      return null;
    } else {
      List<List<double>> relativeSelectionRegionList = [];
      for (Offset offset in object) {
        final point = [offset.dx, offset.dy];
        relativeSelectionRegionList.add(point);
      }
      return relativeSelectionRegionList;
    }
  }
}