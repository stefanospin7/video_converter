import 'package:flutter/material.dart';
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
    Key? key,
    required this.selectedFiles,
    required this.isConverting,
    required this.pickFile,
    required this.convertFiles,
    required this.selectedFps,
    required this.selectedQuality,
    required this.updateFps,
    required this.updateQuality,
    required this.onFileDropped, // Add this parameter
    required this.onFileRemoved, // Add this parameter for file removal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2D), // Dark background color
      body: Column(
        children: [
          Expanded(
            child: DropTarget(
              onDragDone: (details) {
                // Handle file drop here
                List<XFile> droppedFiles = details.files
                    .where((file) => file.path.endsWith('.webm')) // Only accept .webm files
                    .map((file) => XFile(file.path))
                    .where((file) => !isFileDuplicate(file)) // Avoid duplicates
                    .toList();

                if (droppedFiles.isNotEmpty) {
                  onFileDropped(droppedFiles); // Update the files if valid .webm files
                } else {
                  // You can show an error or a toast here if an invalid file is dropped.
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
                              vertical: 8.0, // Reduced vertical padding for compact height
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
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red, // Red color for remove icon
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
                        'No files selected.',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
          ),
          if (isConverting)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 5.0,
              ), // Custom loader with a blue accent and thicker stroke
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligning to the left
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
                    const SizedBox(width: 16), // Add space between dropdowns
                    _buildQualityDropdown(),
                  ],
                ),
                const SizedBox(height: 16),
                // The buttons will span the entire width of the screen
                _buildElevatedButton(
                  text: 'Select Files',
                  onPressed: isConverting ? null : () => pickFile(context),
                  isFullWidth: true, // Set full width
                ),
                const SizedBox(height: 16),
                _buildElevatedButton(
                  text: 'Convert Files',
                  onPressed: isConverting || selectedFiles.isEmpty
                      ? null
                      : () => convertFiles(context),
                  isFullWidth: true, // Set full width
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Check if the file is already in the selected files list
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced horizontal padding for compactness
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
                    fontSize: 14.0, // Match the text size to be compact
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (item) {
          if (item != null) onChanged(item);
        },
        dropdownColor: const Color(0xFF1E1E2D), // Match background
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        isExpanded: false, // Prevent dropdown from stretching
        underline: Container(), // Remove underline
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
    );
  }

  Widget _buildQualityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced horizontal padding for compactness
      child: DropdownButton<int>(
        value: selectedQuality,
        items: [
          DropdownMenuItem<int>(
            value: 0,
            child: Text(
              '  High Quality  ',
              style: TextStyle(
                color: selectedQuality == 0 ? Colors.white : Colors.grey,
                fontSize: 14.0, // Match the text size to be compact
              ),
            ),
          ),
          DropdownMenuItem<int>(
            value: 18,
            child: Text(
              '  Medium Quality  ',
              style: TextStyle(
                color: selectedQuality == 18 ? Colors.white : Colors.grey,
                fontSize: 14.0, // Match the text size to be compact
              ),
            ),
          ),
          DropdownMenuItem<int>(
            value: 45, //51 max
            child: Text( 
              '  Low Quality  ',
              style: TextStyle(
                color: selectedQuality == 51 ? Colors.white : Colors.grey,
                fontSize: 14.0, // Match the text size to be compact
              ),
            ),
          ),
        ],
        onChanged: (quality) {
          if (quality != null) updateQuality(quality);
        },
        dropdownColor: const Color(0xFF1E1E2D), // Match background
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        isExpanded: false, // Prevent dropdown from stretching
        underline: Container(), // Remove underline
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
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
        backgroundColor: onPressed != null ? Colors.black : Colors.grey[600], // Button background color
        padding: const EdgeInsets.symmetric(vertical: 14.0), // Keep the padding the same as before
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: isFullWidth ? Size(double.infinity, 50) : Size(200, 50), // Set width for full screen button
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
