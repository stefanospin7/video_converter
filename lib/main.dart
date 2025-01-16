import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:webm_converter/file_functions.dart';
import 'home_page.dart'; // Import the HomePage widget
import 'info_page.dart'; // Import the InfoPage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WEBM Converter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E1E2D),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E2D),
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFBB86FC), // Purple
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile> selectedFiles = [];
  bool isConverting = false;

  // Add state for FPS and quality
  int _selectedFps = 30; // Default FPS
  int _selectedQuality = 18; // Default quality

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: screenSize.width >= 300 && screenSize.height >= 100
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'utils/photos/icon_512p.png', // Path to your app icon
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('WEBM Converter'),
                ],
              )
            : null, // Hide the title if the screen size is too small
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoPage()),
              );
            },
          ),
        ],
      ),
      body: HomePage(
        selectedFiles: selectedFiles,
        isConverting: isConverting,
        pickFile: _pickFile,
        convertFiles: _convertFiles,
        selectedFps: _selectedFps,
        selectedQuality: _selectedQuality,
        updateFps: (fps) {
          setState(() {
            _selectedFps = fps;
          });
        },
        updateQuality: (quality) {
          setState(() {
            _selectedQuality = quality;
          });
        },
        onFileDropped: (List<XFile> files) {
          setState(() {
            selectedFiles.addAll(files); // Update selected files when files are dropped
          });
        },
        onFileRemoved: (XFile file) {
          setState(() {
            selectedFiles.remove(file); // Remove the selected file from the list
          });
        },
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final files = await pickFile(context); // Your logic for picking files
    setState(() {
      selectedFiles = files;
    });
  }

  Future<void> _convertFiles(BuildContext context) async {
    setState(() {
      isConverting = true;
    });

    await convertFiles(context, selectedFiles, _selectedFps, _selectedQuality);

    setState(() {
      isConverting = false;
      selectedFiles.clear();
    });
  }
}
