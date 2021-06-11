import 'dart:async';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';

class CounterStorage {
  Future<String> get _localPath async {
    createFolder();
    final directory =
        await ExtStorage.getExternalStoragePublicDirectory("Transcribe");

    return directory;
  }

  Future<File> _localFile(String name) async {
    final path = await _localPath;
    return File('$path/$name');
  }

  Future<String> readCounter(String fname) async {
    try {
      final file = await _localFile(fname);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "null";
    }
  }

  Future<File> writeCounter(String counter, String fname) async {
    final file = await _localFile(fname);

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<int> deleteFile(String fname) async {
    try {
      final file = await _localFile(fname);

      await file.delete();
    } catch (e) {
      return 0;
    }
  }

  void createFolder() async {
    String pth =
        await ExtStorage.getExternalStoragePublicDirectory("Transcribe");
    final path = Directory(pth);
    if (!(await path.exists())) {
      path.create();
    }
  }
}
