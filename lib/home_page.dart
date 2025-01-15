import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:webm_converter/custom_audio_player.dart';

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
  bool isMuted = false;
  bool isDarkMode = true;
  bool hasShownNotification = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/utils/user_preferences.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final Map<String, dynamic> json = jsonDecode(contents);
        setState(() {
          isMuted = json['isMuted'] ?? false;
          isDarkMode = json['isDarkMode'] ?? true;
        });
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  Future<void> _savePreferences() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/utils/user_preferences.json');
      final preferences = {
        'isMuted': isMuted,
        'isDarkMode': isDarkMode,
      };
      await file.create(recursive: true); // Make sure the directory exists
      await file.writeAsString(jsonEncode(preferences));
    } catch (e) {
      print("Error saving preferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isScreenLargeEnough = screenWidth >= 300 && screenHeight >= 300;

    if (!isScreenLargeEnough && !hasShownNotification) {
      hasShownNotification = true;
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please resize the window to at least 300x300 to display content.'),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }

    if (isScreenLargeEnough && hasShownNotification) {
      hasShownNotification = false;
    }

    final shouldBlockInteraction = widget.isConverting;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
          body: isScreenLargeEnough
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (screenWidth >= 600)
                          Row(
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Switch(
                                value: isDarkMode,
                                onChanged: (value) {
                                  setState(() {
                                    isDarkMode = value;
                                  });
                                  _savePreferences(); // Save preferences after change
                                },
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                        const SizedBox(width: 16),
                        Text(
                          'Mute',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Switch(
                          value: isMuted,
                          onChanged: (value) {
                            setState(() {
                              isMuted = value;
                              CustomAudioPlayer.muteAudio = value;
                            });
                            _savePreferences(); // Save preferences after change
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
                              print(
                                  'Invalid file dropped. Only .webm files are allowed or duplicates.');
                            }
                          }
                        },
                        child: widget.selectedFiles.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: widget.selectedFiles.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: isDarkMode
                                        ? const Color(0xFF2A2A3E)
                                        : Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 16.0,
                                      ),
                                      title: Text(
                                        widget.selectedFiles[index].name,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        onPressed: shouldBlockInteraction
                                            ? null
                                            : () {
                                                widget.onFileRemoved(widget
                                                    .selectedFiles[index]);
                                                if (!isMuted) {
                                                  CustomAudioPlayer.playAudio(
                                                      'utils/audio/trash_sound.mp3');
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
                                    color: isDarkMode
                                        ? Colors.grey[500]
                                        : Colors.black54,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
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
                            onPressed: shouldBlockInteraction
                                ? null
                                : () => widget.pickFile(context),
                          ),
                          const SizedBox(height: 16),
                          _buildElevatedButton(
                            text: 'Convert Files',
                            onPressed: shouldBlockInteraction ||
                                    widget.selectedFiles.isEmpty
                                ? null
                                : () async {
                                    await widget.convertFiles(context);
                                    if (!isMuted) {
                                      CustomAudioPlayer.playAudio(
                                          'utils/audio/confirmation_sound.mp3');
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        if (shouldBlockInteraction) ...[
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black.withOpacity(0.8),
              dismissible: false,
            ),
          ),
          const Positioned.fill(
            child: Center(
              child: SpinKitFadingCircle(
                color: Color.fromARGB(255, 139, 172, 230),
                size: 50.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool isFileDuplicate(XFile file) {
    return widget.selectedFiles
        .any((existingFile) => existingFile.path == file.path);
  }

  Widget _buildDropdown({
    required int value,
    required List<int> items,
    required Function(int) onChanged,
    required String label,
  }) {
    return DropdownButton<int>(
      value: value,
      items: items
          .map(
            (item) => DropdownMenuItem<int>(
              value: item,
              child: Text('$item $label'),
            ),
          )
          .toList(),
      onChanged: (item) {
        if (item != null) onChanged(item);
      },
    );
  }

  Widget _buildQualityDropdown() {
    return DropdownButton<int>(
      value: widget.selectedQuality,
      items: [
        DropdownMenuItem(value: 0, child: Text('High Quality')),
        DropdownMenuItem(value: 18, child: Text('Medium Quality')),
        DropdownMenuItem(value: 30, child: Text('Low Quality')),
      ],
      onChanged: (quality) {
        if (quality != null) widget.updateQuality(quality);
      },
    );
  }

  Widget _buildElevatedButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
