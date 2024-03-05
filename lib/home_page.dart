import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<XFile> selectedFiles;
  final bool isConverting;
  final Function(BuildContext) pickFile;
  final Function(BuildContext) convertFiles;

  const HomePage({
    Key? key,
    required this.selectedFiles,
    required this.isConverting,
    required this.pickFile,
    required this.convertFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected one or multiple files:",
                style: TextStyle(
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
              Expanded(
                child: ListView.builder(
                  itemCount: selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = selectedFiles[index];
                    return ListTile(
                      leading: getFileIcon(file),
                      title: Text(
                        file.name,
                        style: TextStyle(color: Colors.black),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: isConverting ? null : () => pickFile(context),
                    child: const Text("Pick File"),
                  ),
                  if (!isConverting)
                    ElevatedButton(
                      onPressed:
                          selectedFiles.isEmpty ? null : () => convertFiles(context),
                      child: const Text("Convert"),
                    ),
                  if (isConverting)
                    Row(
                      children: [
                        const Text('Please wait, files are converting'),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                ],
              ),
            ],
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
