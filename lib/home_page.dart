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
    return Column(
      children: [
        Expanded(
          child: selectedFiles.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: selectedFiles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        selectedFiles[index].name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No files selected.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 18),
                  ),
                ),
        ),
        if (isConverting)
          const Center(
            child: SpinKitFadingCircle(
              color: Colors.purpleAccent,
              size: 50.0,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<int>(
                value: selectedFps,
                items: [24, 30, 60, 120]
                    .map((fps) => DropdownMenuItem<int>(
                          value: fps,
                          child: Text(
                            '$fps FPS',
                            style: TextStyle(
                              color: selectedFps == fps
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (fps) {
                  if (fps != null) {
                    updateFps(fps);
                  }
                },
                dropdownColor: const Color(0xFF1E1E2D), // Match background
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              DropdownButton<int>(
                value: selectedQuality,
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text(
                      'High Quality',
                      style: TextStyle(
                        color: selectedQuality == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 18,
                    child: Text(
                      'Medium Quality',
                      style: TextStyle(
                        color: selectedQuality == 18
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                  DropdownMenuItem<int>(
                    value: 51,
                    child: Text(
                      'Low Quality',
                      style: TextStyle(
                        color: selectedQuality == 51
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
                onChanged: (quality) {
                  if (quality != null) {
                    updateQuality(quality);
                  }
                },
                dropdownColor: const Color(0xFF1E1E2D), // Match background
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isConverting ? null : () => pickFile(context),
                child: const Text('Select Files'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isConverting || selectedFiles.isEmpty
                    ? null
                    : () => convertFiles(context),
                child: const Text('Convert Files'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
