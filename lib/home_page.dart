import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit
import 'package:desktop_drop/desktop_drop.dart'; // Import desktop_drop
import 'package:file_selector/file_selector.dart'; // For selecting files if needed

class HomePage extends StatelessWidget {
  final List<XFile> selectedFiles;
  final bool isConverting;
  final Future<void> Function(BuildContext context) pickFile;
  final Future<void> Function(BuildContext context) convertFiles;
  final int selectedFps;
  final int selectedQuality;
  final Function(int) updateFps;
  final Function(int) updateQuality;
  final Function(List<XFile>) onFileDropped; // Callback to handle file drops
  final Function(XFile) onFileRemoved; // Callback to handle file removal

  const HomePage({
    super.key,
    required this.selectedFiles,
    required this.isConverting,
    required this.pickFile,
    required this.convertFiles,
    required this.selectedFps,
    required this.selectedQuality,
    required this.updateFps,
    required this.updateQuality,
    required this.onFileDropped,
    required this.onFileRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2D), // Dark background color
      body: Column(
        children: [
          Expanded(
            child: DropTarget(
              onDragDone: (details) {
                List<XFile> droppedFiles = details.files
                    .where((file) => file.path.endsWith('.webm')) // Only accept .webm files
                    .map((file) => XFile(file.path))
                    .where((file) => !isFileDuplicate(file)) // Avoid duplicates
                    .toList();

                if (droppedFiles.isNotEmpty) {
                  onFileDropped(droppedFiles);
                } else {
                  print('Invalid file dropped. Only .webm files are allowed or duplicates.');
                }
              },
              onDragEntered: (_) {},
              onDragExited: (_) {},
              child: selectedFiles.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFF2A2A3E),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            title: Text(
                              selectedFiles[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white, // White trash icon
                              ),
                              onPressed: () {
                                onFileRemoved(selectedFiles[index]);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Click "Select Files" or drag and drop files here',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
          ),
          if (isConverting)
            const Center(
              child: SpinKitFadingCircle(
                color: Color.fromARGB(255, 139, 172, 230), // Custom color
                size: 50.0, // Custom size
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildDropdown(
                      value: selectedFps,
                      items: [24, 30, 60, 120],
                      onChanged: updateFps,
                      label: 'FPS',
                    ),
                    const SizedBox(width: 16),
                    _buildQualityDropdown(),
                  ],
                ),
                const SizedBox(height: 16),
                _buildElevatedButton(
                  text: 'Select Files',
                  onPressed: isConverting ? null : () => pickFile(context),
                  isFullWidth: true,
                ),
                const SizedBox(height: 16),
                _buildElevatedButton(
                  text: 'Convert Files',
                  onPressed: isConverting || selectedFiles.isEmpty
                      ? null
                      : () => convertFiles(context),
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isFileDuplicate(XFile file) {
    return selectedFiles.any((existingFile) => existingFile.path == file.path);
  }

  Widget _buildDropdown({
    required int value,
    required List<int> items,
    required Function(int) onChanged,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<int>(
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem<int>(
                value: item,
                child: Text(
                  '$item $label',
                  style: TextStyle(
                    color: value == item ? Colors.white : Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (item) {
          if (item != null) onChanged(item);
        },
        dropdownColor: const Color(0xFF1E1E2D),
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        isExpanded: false,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  Widget _buildQualityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<int>(
        value: selectedQuality,
        items: [
          DropdownMenuItem<int>(
            value: 0,
            child: Text(
              '  High Quality  ',
              style: TextStyle(
                color: selectedQuality == 0 ? Colors.white : Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
          DropdownMenuItem<int>(
            value: 18,
            child: Text(
              '  Medium Quality  ',
              style: TextStyle(
                color: selectedQuality == 18 ? Colors.white : Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
          DropdownMenuItem<int>(
            value: 45,
            child: Text(
              '  Low Quality  ',
              style: TextStyle(
                color: selectedQuality == 45 ? Colors.white : Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
        onChanged: (quality) {
          if (quality != null) updateQuality(quality);
        },
        dropdownColor: const Color(0xFF1E1E2D),
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        isExpanded: false,
        underline: Container(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  Widget _buildElevatedButton({
    required String text,
    required VoidCallback? onPressed,
    bool isFullWidth = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? Colors.black : Colors.grey[600],
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: isFullWidth ? const Size(double.infinity, 50) : const Size(200, 50),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
