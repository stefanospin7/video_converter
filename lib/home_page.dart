import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this package
import 'package:file_selector/file_selector.dart';

class HomePage extends StatelessWidget {
  final List<XFile> selectedFiles;
  final bool isConverting;
  final Future<void> Function(BuildContext context) pickFile;
  final Future<void> Function(BuildContext context) convertFiles;
  final int selectedFps;
  final int selectedQuality;
  final Function(int) updateFps;
  final Function(int) updateQuality;

  const HomePage({
    Key? key,
    required this.selectedFiles,
    required this.isConverting,
    required this.pickFile,
    required this.convertFiles,
    required this.selectedFps,
    required this.selectedQuality,
    required this.updateFps,
    required this.updateQuality,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: isConverting ? null : () => pickFile(context),
            child: const Text('Select Files'),
          ),
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: selectedFps,
            items: [24, 30, 60, 120]
                .map((fps) => DropdownMenuItem<int>(
                      value: fps,
                      child: Text('$fps FPS'),
                    ))
                .toList(),
            onChanged: (fps) {
              if (fps != null) {
                updateFps(fps);
              }
            },
            hint: const Text('Select FPS'),
          ),
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: selectedQuality,
            items: [
              const DropdownMenuItem<int>(
                value: 0,
                child: Text('High Quality'),
              ),
              const DropdownMenuItem<int>(
                value: 18,
                child: Text('Medium Quality'),
              ),
              const DropdownMenuItem<int>(
                value: 51,
                child: Text('Low Quality'),
              ),
            ],
            onChanged: (quality) {
              if (quality != null) {
                updateQuality(quality);
              }
            },
            hint: const Text('Select Quality'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isConverting || selectedFiles.isEmpty
                ? null
                : () => convertFiles(context),
            child: const Text('Convert Files'),
          ),
          const SizedBox(height: 16),
          if (selectedFiles.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedFiles[index].name),
                  );
                },
              ),
            ),
          if (isConverting)
            Expanded(
              child: Center(
                child: SpinKitFadingCircle(
                  color: Colors.purpleAccent,
                  size: 50.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
