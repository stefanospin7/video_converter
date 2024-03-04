import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

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
      home: const MyHomePage(),
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
                "Selected Files:",
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
                      leading: _getFileIcon(file),
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
              ElevatedButton(
                onPressed: () => _pickFile(context),
                child: const Text("Pick File"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final typeGroup = XTypeGroup(label: 'Video', extensions: ['webm']);
    final files = await openFiles(acceptedTypeGroups: [typeGroup]);

    setState(() {
      selectedFiles = files;
    });
  }

  Widget _getFileIcon(XFile file) {
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
