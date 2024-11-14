import 'dart:async';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<XFile> selectedFiles;
  final bool isConverting;
  final Function(BuildContext) pickFile;
  final Function(BuildContext) convertFiles;

  const HomePage({
    super.key,
    required this.selectedFiles,
    required this.isConverting,
    required this.pickFile,
    required this.convertFiles,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSnackBar = false; // Track if SnackBar is already shown
  bool _initTimeElapsed = false; // Flag to delay the initial check

  @override
  void initState() {
    super.initState();
    // Start a timer to set _initTimeElapsed to true after 3 seconds
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _initTimeElapsed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool showFullContent = constraints.maxHeight > 300;

              // Only show the SnackBar if the timer has elapsed and the screen is too small (this prevent initial unwanted warnings)
              if (_initTimeElapsed && !showFullContent && !_showSnackBar) {
                _showSnackBar = true; // Mark SnackBar as shown
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("This window is too small. Please enlarge it to fully access the app features."),
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              } else if (showFullContent) {
                _showSnackBar = false; // Reset when the buttons are visible
              }

              // If the screen height is too small, show nothing
              if (!showFullContent) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.selectedFiles.isEmpty
                        ? "Select one or multiple files:"
                        : "Selected files:",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(height: 20, thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = widget.selectedFiles[index];
                        return ListTile(
                          leading: getFileIcon(file),
                          title: Text(
                            file.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 20, thickness: 2),
                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 300) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    widget.isConverting ? null : () => widget.pickFile(context),
                                child: const Text("Pick File"),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: widget.selectedFiles.isEmpty || widget.isConverting
                                    ? null
                                    : () => widget.convertFiles(context),
                                child: const Text("Convert"),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      widget.isConverting ? null : () => widget.pickFile(context),
                                  child: const Text("Pick File"),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.selectedFiles.isEmpty || widget.isConverting
                                      ? null
                                      : () => widget.convertFiles(context),
                                  child: const Text("Convert"),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: widget.isConverting
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : null,
    );
  }

  Widget getFileIcon(XFile file) {
    IconData iconData;
    if (file.path.endsWith('.webm')) {
      iconData = Icons.video_library;
    } else {
      iconData = Icons.file_copy;
    }
    return Icon(
      iconData,
      color: Colors.white,
    );
  }
}
