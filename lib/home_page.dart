import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit
import 'package:desktop_drop/desktop_drop.dart'; // Import desktop_drop
import 'package:file_selector/file_selector.dart';
import 'package:webm_converter/custom_audio_player.dart'; // For selecting files if needed

class HomePage extends StatefulWidget {
  final List<XFile> selectedFiles;
  final bool isConverting;
  final Future<void> Function(BuildContext context) pickFile;
  final Future<void> Function(BuildContext context) convertFiles;
  final int selectedFps;
  final int selectedQuality;
  final Function(int) updateFps;
  final Function(int) updateQuality;
  final Function(List<XFile>) onFileDropped;
  final Function(XFile) onFileRemoved;

  HomePage({
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMuted = false; // Mute state (local)
  bool isDarkMode = true; // Dark mode state

  @override
  Widget build(BuildContext context) {
    bool shouldBlockInteraction = widget.isConverting || widget.selectedFiles.isNotEmpty && widget.isConverting;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              // Dark/Light mode switch
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Dark Mode'),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
          body: Column(
            children: [
              // Mute Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Mute',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black, // Adjust mute label text color
                    ),
                  ),
                  Switch(
                    value: isMuted,
                    onChanged: (value) {
                      setState(() {
                        isMuted = value;
                        CustomAudioPlayer.muteAudio = value; // Update global mute state
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              Expanded(
                child: DropTarget(
                  onDragDone: (details) {
                    if (!shouldBlockInteraction) {
                      List<XFile> droppedFiles = details.files
                          .where((file) => file.path.endsWith('.webm'))
                          .map((file) => XFile(file.path))
                          .where((file) => !isFileDuplicate(file))
                          .toList();

                      if (droppedFiles.isNotEmpty) {
                        widget.onFileDropped(droppedFiles);
                      } else {
                        print('Invalid file dropped. Only .webm files are allowed or duplicates.');
                      }
                    }
                  },
                  onDragEntered: (_) {},
                  onDragExited: (_) {},
                  child: widget.selectedFiles.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: widget.selectedFiles.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: isDarkMode ? const Color(0xFF2A2A3E) : Colors.grey[300],
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                title: Text(
                                  widget.selectedFiles[index].name,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  onPressed: shouldBlockInteraction
                                      ? null
                                      : () {
                                          widget.onFileRemoved(widget.selectedFiles[index]);
                                          // Play the trash sound, respecting mute setting
                                          if (!isMuted) {
                                            CustomAudioPlayer.playAudio('utils/audio/trash_sound.mp3');
                                          }
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
                              color: isDarkMode ? Colors.grey[500] : Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        ),
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
                          value: widget.selectedFps,
                          items: [24, 30, 60, 120],
                          onChanged: widget.updateFps,
                          label: 'FPS',
                        ),
                        const SizedBox(width: 16),
                        _buildQualityDropdown(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildElevatedButton(
                      text: 'Select Files',
                      onPressed: shouldBlockInteraction ? null : () => widget.pickFile(context),
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 16),
                    _buildElevatedButton(
                      text: 'Convert Files',
                      onPressed: shouldBlockInteraction || widget.selectedFiles.isEmpty
                          ? null
                          : () async {
                              await widget.convertFiles(context);

                              // Play success sound after conversion, respecting mute setting
                              if (!isMuted) {
                                CustomAudioPlayer.playAudio('utils/audio/confirmation_sound.mp3');
                              }
                            },
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (shouldBlockInteraction) ...[
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.8), // Semi-transparent overlay
              dismissible: false, // Prevent dismissing the barrier
            ),
          ),
          const Positioned.fill(
            child: Center(
              child: SpinKitFadingCircle(
                color: Color.fromARGB(255, 139, 172, 230), // Custom color
                size: 50.0, // Custom size
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool isFileDuplicate(XFile file) {
    return widget.selectedFiles.any((existingFile) => existingFile.path == file.path);
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
                  color: value == item
                      ? (isDarkMode ? Colors.white : Colors.black) // Selected value color
                      : (isDarkMode ? Colors.grey : Colors.black.withOpacity(0.6)), // Unselected color
                  fontSize: 14.0,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (item) {
        if (item != null) onChanged(item);
      },
      dropdownColor: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white, // Background color of dropdown
      iconEnabledColor: isDarkMode ? Colors.white : Colors.black, // Arrow icon color
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Text color inside the dropdown
      isExpanded: false,
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down),
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}


Widget _buildQualityDropdown() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: DropdownButton<int>(
      value: widget.selectedQuality,
      items: [
        DropdownMenuItem<int>(
          value: 0,
          child: Text(
            '  High Quality  ',
            style: TextStyle(
              color: widget.selectedQuality == 0
                  ? (isDarkMode ? Colors.white : Colors.black) // Selected color
                  : (isDarkMode ? Colors.grey : Colors.black.withOpacity(0.6)), // Unselected color
              fontSize: 14.0,
            ),
          ),
        ),
        DropdownMenuItem<int>(
          value: 18,
          child: Text(
            '  Medium Quality  ',
            style: TextStyle(
              color: widget.selectedQuality == 18
                  ? (isDarkMode ? Colors.white : Colors.black) // Selected color
                  : (isDarkMode ? Colors.grey : Colors.black.withOpacity(0.6)), // Unselected color
              fontSize: 14.0,
            ),
          ),
        ),
        DropdownMenuItem<int>(
          value: 30,
          child: Text(
            '  Low Quality  ',
            style: TextStyle(
              color: widget.selectedQuality == 30
                  ? (isDarkMode ? Colors.white : Colors.black) // Selected color
                  : (isDarkMode ? Colors.grey : Colors.black.withOpacity(0.6)), // Unselected color
              fontSize: 14.0,
            ),
          ),
        ),
      ],
      onChanged: (quality) {
        if (quality != null) widget.updateQuality(quality);
      },
      dropdownColor: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white, // Background color of dropdown
      iconEnabledColor: isDarkMode ? Colors.white : Colors.black, // Arrow icon color
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Text color inside the dropdown
      isExpanded: false,
      underline: Container(),
      icon: const Icon(Icons.arrow_drop_down),
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
        backgroundColor: isDarkMode ? Colors.black : Colors.black, // Same for both modes
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: isFullWidth ? const Size(double.infinity, 50) : const Size(200, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.grey, // Ensure button text stays white
        ),
      ),
    );
  }
}
