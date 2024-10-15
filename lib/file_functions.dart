import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

Future<List<XFile>> pickFile(BuildContext context) async {
  const typeGroup = XTypeGroup(label: 'Video', extensions: ['webm']);
  return await openFiles(acceptedTypeGroups: [typeGroup]);
}

Future<void> convertFiles(BuildContext context, List<XFile> selectedFiles) async {
  if (selectedFiles.isEmpty) return;

  // Check if ffmpeg is installed
  bool isFfmpegInstalled = await _checkFfmpegInstallation();

  if (!isFfmpegInstalled) {
    if (context.mounted) {
      bool? installFfmpeg = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("FFmpeg not found"),
            content: const Text("FFmpeg is not installed. Do you want to install it?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );

      if (installFfmpeg == true) {
        await _installFfmpeg(context);
      }
    }
    return; // Exit the function if ffmpeg is not installed
  }

  // Proceed with conversion if ffmpeg is installed
  for (final file in selectedFiles) {
    if (file.path.endsWith('.webm')) {
      try {
        final outputFilePath = '${file.path.split('.')[0]}.mp4';
        final outputFile = File(outputFilePath);
        if (await outputFile.exists()) {
          final outputFileName = '${file.path.split('.')[0]}_copy.mp4';
          await outputFile.rename(outputFileName);
        }

        // Start the ffmpeg process
        final process = await Process.start(
          'ffmpeg',
          [
            '-i',
            file.path,
            '-vf',
            'scale=trunc(iw/2)*2:trunc(ih/2)*2',
            outputFilePath,
          ],
          mode: ProcessStartMode.normal,
        );

        // Capture stdout and stderr
        process.stdout.transform(utf8.decoder).listen((event) {
          print('stdout: $event');
        });

        process.stderr.transform(utf8.decoder).listen((event) {
          print('stderr: $event');
        });

        // Wait for the process to finish
        await process.exitCode;

        // Show completion dialog
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Conversion Completed"),
                content: Text("Conversion of ${file.name} to MP4 completed!"),
              );
            },
          );

          // Dismiss the completion dialog after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      } catch (e) {
        // Show error dialog safely
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error occurred"),
                content: Text("Error occurred during conversion: $e"),
              );
            },
          );
        }
        return; // Exit the function immediately after showing the error dialog
      }
    }
  }
}

Future<bool> _checkFfmpegInstallation() async {
  try {
    final result = await Process.run('ffmpeg', ['-version']);
    return result.exitCode == 0; // 0 means ffmpeg is installed
  } catch (e) {
    return false; // Error occurred, ffmpeg is not installed
  }
}

Future<void> _installFfmpeg(BuildContext context) async {
  String installCommand;

  // Suggest installation commands based on common distributions
  if (await _isDebianBased()) {
    installCommand = 'apt install ffmpeg -y';
  } else if (await _isRedHatBased()) {
    installCommand = 'dnf install ffmpeg -y';
  } else {
    installCommand = '';
  }

  if (installCommand.isNotEmpty) {
    // Run the installation command using pkexec
    final process = await Process.start(
      'pkexec',
      ['bash', '-c', installCommand],
      mode: ProcessStartMode.normal,
    );

    // Capture output
    process.stdout.transform(utf8.decoder).listen((event) {
      print('stdout: $event');
    });

    process.stderr.transform(utf8.decoder).listen((event) {
      print('stderr: $event');
    });

    // Wait for the process to finish
    await process.exitCode;

    // Show confirmation dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Installation Completed"),
            content: const Text("FFmpeg installation is complete!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  } else {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Unsupported Distribution"),
            content: const Text("Your Linux distribution is not supported for automatic installation."),
          );
        },
      );
    }
  }
}

Future<bool> _isDebianBased() async {
  return await _checkDistribution("debian") || await _checkDistribution("ubuntu");
}

Future<bool> _isRedHatBased() async {
  return await _checkDistribution("fedora") || await _checkDistribution("centos");
}

Future<bool> _checkDistribution(String keyword) async {
  final result = await Process.run('lsb_release', ['-is']);
  return result.stdout.toString().trim().toLowerCase().contains(keyword); // Use result.stdout directly
}
