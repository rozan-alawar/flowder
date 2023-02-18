import 'dart:io';

import 'package:download_files/model/file_model.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadNotifier extends ChangeNotifier {
  String? path;
  DownloaderUtils? options;
  DownloaderCore? core;
  // bool isLoading = false;
  double progress = 0;
  List<FileModel> fileList = [];

  bool isPaused = false;

  Ref ref;
  DownloadNotifier({
    required this.ref,
  });

  generateFiles() {
    fileList
      ..add(FileModel(
        fileName: "loremipsum.pdf",
        url:
            "https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf",
        progress: 0.0,
        icon: Icons.picture_as_pdf,
      ))
      ..add(FileModel(
        fileName: "music.mp3",
        url: "https://cdn.pixabay.com/audio/2023/02/03/audio_534a89f910.mp3",
        progress: 0.0,
        icon: Icons.my_library_music_rounded,
      ))
      ..add(FileModel(
        fileName: "image.jpg",
        url:
            "https://cdn.pixabay.com/photo/2019/03/28/20/22/owl-4087984_960_720.png",
        progress: 0.0,
        icon: Icons.image,
      ))
      ..add(FileModel(
        fileName: "5MB.rar",
        url: "http://ipv4.download.thinkbroadband.com/5MB.zip",
        progress: 0.0,
        icon: Icons.folder_zip,
      ));
  }

  Future<bool> setPath() async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            await _requestPermission(Permission.accessMediaLocation) &&
            await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.example.download_files/files
          String newPath = '';
          List<String> folders = directory!.path.split('/');
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != 'Android') {
              newPath += '${Platform.pathSeparator}$folder';
            } else {
              break;
            }
          }
          newPath = '$newPath${Platform.pathSeparator}downloadFiles';
          directory = Directory(newPath);
          bool hasExisted = await directory.exists();
          if (!hasExisted) {
            directory.create();
          }
          print(directory.path);

          path = newPath;
          notifyListeners();
        } else {
          return false;
        }
      }
    } catch (e) {
      print('$e , error has occurred');
    }

    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void downloadFile(String url, int index) async {
    options = DownloaderUtils(
      progress: ProgressImplementation(),
      file: File('$path/myFile.${url.split('.').last}'),
      onDone: () {
        fileList[index].progress = 0;
        OpenFile.open('$path/myFile.${url.split('.').last}');
        notifyListeners();
      },
      progressCallback: (current, total) {
        final progress = (current / total);
        fileList[index].progress = progress;
        notifyListeners();
        print('Downloading: ${(fileList[index].progress!) * 100}');
      },
    );
    try {
      core = await Flowder.download(url, options!);

      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  cancelDownload(int index) async {
    core!.cancel();
    fileList[index].progress = 0;
    print('canceled');
    notifyListeners();
  }

  pauseDownload() {
    isPaused = true;
    notifyListeners();
    core!.pause();
    print('pused');
    notifyListeners();
  }

  resumeDownload() {
    isPaused = false;
    notifyListeners();
    core!.resume();
    print('resumed');

    notifyListeners();
  }

  Future<bool> downloadFile2(String url) async {
    try {
      final options = DownloaderUtils(
        progress: ProgressImplementation(),
        file: File('$path/myFile.${url.split('.').last}'),
        onDone: () {
          progress = 0;
          OpenFile.open('$path/myFile.${url.split('.').last}');
          notifyListeners();
        },
        progressCallback: (current, total) {
          final progress = (current / total);
          this.progress = progress;
          notifyListeners();
          print('Downloading: ${progress * 100}');
        },
      );
      core = await Flowder.download(url, options);
      print(await options.progress.getProgress(url));
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}

final downloadProvider =
    ChangeNotifierProvider((ref) => DownloadNotifier(ref: ref));
