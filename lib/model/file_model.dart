import 'package:flutter/material.dart';

class FileModel {
  FileModel({
    this.fileName,
    this.url,
    this.progress,
    this.icon,
  });

  String? fileName;
  String? url;
  double? progress;
  IconData? icon;

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        fileName: json["fileName"],
        url: json["url"],
        progress:
            json["progress"]! == null ? null : json["progress"].toDouble(),
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName,
        "url": url,
        "progress": progress,
        "icon": icon,
      };

  @override
  String toString() {
    return 'file name: $fileName, progress: $progress ';
  }
}
