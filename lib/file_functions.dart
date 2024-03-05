import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

Future<List<XFile>> pickFile(BuildContext context) async {
  final typeGroup = XTypeGroup(label: 'Video', extensions: ['webm']);
  return await openFiles(acceptedTypeGroups: [typeGroup]);
}

Future<void> convertFiles(BuildContext context, List<XFile> selectedFiles) async {
  // Ensure there are selected files
  if (selectedFiles.isEmpty) return;

  // Set conversion status to true
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Conversion started..."),
    ),
  );

  for (final file in selectedFiles) {
    if (file.path.endsWith('.webm')) {
      try {
        final outputFilePath = '${file.path.split('.')[0]}.mp4';
        final outputFile = File(outputFilePath);
        if (await outputFile.exists()) {
          final outputFileName = '${file.path.split('.')[0]}_copy.mp4';
          await outputFile.rename(outputFileName);
        }
        final process = await Process.start(
          'ffmpeg',
          [
            '-i',
            file.path,
            '-vf',
            'scale=trunc(iw/2)*2:trunc(ih/2)*2',
            outputFilePath,
          ],
        );

        process.stdout.listen((event) {
          print('stdout: ${String.fromCharCodes(event)}');
        });

        process.stderr.listen((event) {
          print('stderr: ${String.fromCharCodes(event)}');
        });

        await process.exitCode;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Conversion of ${file.name} to MP4 completed!"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error occurred during conversion: $e"),
          ),
        );
      }
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Conversion completed!"),
    ),
  );
}
