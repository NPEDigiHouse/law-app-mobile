// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:law_app/core/utils/http_client.dart';

class FileService {
  static Future<File?> downloadFile(
      {required String url, String? fileName}) async {
    try {
      // Get application directory
      final directory = await getApplicationDocumentsDirectory();

      // Define file name
      final name = fileName ?? url.split('/').last;

      // Create file from path
      final file = File('${directory.path}/$name');

      // Create request and get response
      final response = await HttpClient.client.get(Uri.parse(url));

      // Writes a list of bytes to a file
      return file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }

  static Future<OpenResult> openFile({required String path}) async {
    return await OpenFile.open(path);
  }
}
