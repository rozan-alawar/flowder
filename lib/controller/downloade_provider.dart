import 'dart:io';

import 'package:download_files/model/file_model.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadNotifier extends ChangeNotifier {
  String? path;
  DownloaderUtils? options;
  DownloaderCore? core;
  bool isLoading = false;
  Ref ref;
  DownloadNotifier({
    required this.ref,
  });

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

  Future<bool> downloadFile(String url, double progress, int index) async {
    final list = ref.read(fileProvider);
    try {
      options = DownloaderUtils(
        progress: ProgressImplementation(),
        file: File('$path/myFile.${url.split('.').last}'),
        onDone: () {
          progress = 0;
          list[index].progress = 0;
          OpenFile.open('$path/myFile.${url.split('.').last}');
          notifyListeners();
        },
        progressCallback: (current, total) {
          progress = (current / total);
          list[index].progress = progress;
          notifyListeners();
          print('Downloading: ${progress * 100}');
        },
      );

      core = await Flowder.download(url, options!);
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}

final downloadProvider =
    ChangeNotifierProvider((ref) => DownloadNotifier(ref: ref));
