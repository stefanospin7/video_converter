import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'home_page.dart';
import 'file_functions.dart';
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
          bodyMedium: TextStyle(color: Colors.white), // Updated
          bodySmall: TextStyle(color: Colors.white70), // Updated
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('WEBM Converter'),
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
        selectedFps: _selectedFps, // Pass FPS
        selectedQuality: _selectedQuality, // Pass quality
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
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final files = await pickFile(context);

    setState(() {
      selectedFiles = files;
    });
  }

  Future<void> _convertFiles(BuildContext context) async {
    setState(() {
      isConverting = true;
    });

    // Pass FPS and quality to convertFiles
    await convertFiles(context, selectedFiles, _selectedFps, _selectedQuality);

    setState(() {
      isConverting = false;
      selectedFiles.clear();
    });
  }
}
