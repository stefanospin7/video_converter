import 'dart:async';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

Future<List<XFile>> pickFile(BuildContext context) async {
  const typeGroup = XTypeGroup(label: 'Video', extensions: ['webm']);
  return await openFiles(acceptedTypeGroups: [typeGroup]);
}

Future<void> convertFiles(BuildContext context, List<XFile> selectedFiles) async {
  // Ensure there are selected files
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
        // Determine the distribution and install ffmpeg
        await _installFfmpeg(context);
      }
    }
    return; // Exit the function if ffmpeg is not installed
  }

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
                title: const Text("Error occurred or ffmpeg installation required"),
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
    installCommand = 'sudo apt install ffmpeg -y';
  } else if (await _isRedHatBased()) {
    installCommand = 'sudo dnf install ffmpeg -y';
  } else {
    // You can add more distributions as needed
    installCommand = '';
  }

  if (installCommand.isNotEmpty) {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Install FFmpeg"),
          content: Text("Please run the following command in your terminal:\n\n$installCommand"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    // After confirmation, you could execute the command if you want
    // For now, we just prompt the user to run it manually
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
  // Check for Debian based distributions (like Ubuntu)
  return await _checkDistribution("debian") || await _checkDistribution("ubuntu");
}

Future<bool> _isRedHatBased() async {
  // Check for Red Hat based distributions (like CentOS, Fedora)
  return await _checkDistribution("fedora") || await _checkDistribution("centos");
}

Future<bool> _checkDistribution(String keyword) async {
  final result = await Process.run('lsb_release', ['-is']);
  return result.stdout.toString().trim().toLowerCase().contains(keyword); // Use result.stdout directly
}
