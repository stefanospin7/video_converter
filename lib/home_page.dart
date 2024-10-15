import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check if the available height is sufficient to show all components
              bool showFullContent = constraints.maxHeight > 300;

              // If the screen height is too small, show nothing
              if (!showFullContent) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedFiles.isEmpty
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
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
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
                                    isConverting ? null : () => pickFile(context),
                                child: const Text("Pick File"),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: selectedFiles.isEmpty || isConverting
                                    ? null
                                    : () => convertFiles(context),
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
                                      isConverting ? null : () => pickFile(context),
                                  child: const Text("Pick File"),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: selectedFiles.isEmpty || isConverting
                                      ? null
                                      : () => convertFiles(context),
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
      floatingActionButton: isConverting
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
