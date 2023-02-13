import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

List<FileModel> fileList = [
  FileModel(
    fileName: "loremipsum.pdf",
    url:
        "https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf",
    progress: 0.0,
    icon: Icons.picture_as_pdf,
  ),
  FileModel(
    fileName: "5MB.rar",
    url: "http://ipv4.download.thinkbroadband.com/5MB.zip",
    progress: 0.0,
    icon: Icons.folder_zip,
  ),
  FileModel(
    fileName: "image.jpg",
    url:
        "https://cdn.pixabay.com/photo/2019/03/28/20/22/owl-4087984_960_720.png",
    progress: 0.0,
    icon: Icons.image,
  ),
  FileModel(
    fileName: "music.mp3",
    url: "https://cdn.pixabay.com/audio/2023/02/03/audio_534a89f910.mp3",
    progress: 0.0,
    icon: Icons.my_library_music_rounded,
  )
];

final fileProvider = Provider((ref) => fileList);
