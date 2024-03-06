// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:law_app/core/utils/http_client.dart';

class FileService {
  static Future<String?> downloadFile({
    required String url,
    String? fileName,
  }) async {
    try {
      // Create request
      final response = await HttpClient.client.get(Uri.parse(url));

      // Get application directory
      final directory = await getApplicationDocumentsDirectory();

      // Define file name
      final name = fileName ?? p.basename(url);

      // Writes a list of bytes to a file
      final file = await File('${directory.path}/$name')
          .writeAsBytes(response.bodyBytes);

      return file.path;
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }

  static Future<String?> pickFile({required List<String> extensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );

      return result?.files.first.path;
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }
}
