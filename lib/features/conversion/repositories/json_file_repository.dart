import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:sm_flutter_base/sm_flutter_base.dart';

JsonFileRepository get jsonFileRepository => Get.find<JsonFileRepository>();

class JsonFileRepository extends AppRepository {
  Future<String?> pickJsonPath() {
    return execute(() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
      );
      return result?.files.single.path;
    });
  }

  Future<dynamic> parseFile(String path) {
    return execute(() async {
      final file = File(path);
      if (!await file.exists()) {
        throw const ValidationException(
          message: 'The selected JSON file no longer exists.',
        );
      }
      late final String text;
      try {
        text = await file.readAsString();
      } on FileSystemException catch (e, stackTrace) {
        throw CacheException(
          message: 'Failed to read the JSON file.',
          details: e.message,
          stackTrace: stackTrace,
        );
      }
      if (text.trim().isEmpty) {
        throw const ValidationException(
          message: 'The selected file is empty.',
        );
      }
      return jsonDecode(text);
    });
  }
}
