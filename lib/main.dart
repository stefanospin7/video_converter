import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'home_page.dart';
import 'file_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const customSwatch = MaterialColor(
    0xFF007AFF,
    <int, Color>{
      50: Color(0xFFE5F3FF),
      100: Color(0xFFBFD9FF),
      200: Color(0xFF99BEFF),
      300: Color(0xFF73A4FF),
      400: Color(0xFF4D8AFF),
      500: Color(0xFF007AFF),
      600: Color(0xFF0066E6),
      700: Color(0xFF005CD1),
      800: Color(0xFF0052BD),
      900: Color(0xFF0047A3),
    },
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WEBM Converter',
      theme: ThemeData(
        primarySwatch: customSwatch,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: customSwatch,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile> selectedFiles = [];
  bool isConverting = false;

  @override
  Widget build(BuildContext context) {
    return HomePage(
      selectedFiles: selectedFiles,
      isConverting: isConverting,
      pickFile: _pickFile,
      convertFiles: _convertFiles,
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

    await convertFiles(context, selectedFiles);

    setState(() {
      isConverting = false;
      selectedFiles.clear();
    });
  }
}
