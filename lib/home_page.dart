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
      appBar: AppBar(
        title: const Text(
          "WEBM Converter",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedFiles.isEmpty
                      ? "Select one or multiple files:"
                      : "Selected files:",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 2,
                ),
                SizedBox(
                  height: 200, // Set a fixed height for the list view
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = selectedFiles[index];
                      return ListTile(
                        leading: getFileIcon(file),
                        title: Text(
                          file.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 2,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: isConverting ? null : () => pickFile(context),
                        child: const Text("Pick File"),
                      ),
                      const SizedBox(height: 10), // Space between buttons
                      if (!isConverting)
                        ElevatedButton(
                          onPressed: selectedFiles.isEmpty
                              ? null
                              : () => convertFiles(context),
                          child: const Text("Convert"),
                        ),
                      if (isConverting)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text('Please wait, files are converting'),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      color: Colors.black,
    );
  }
}
