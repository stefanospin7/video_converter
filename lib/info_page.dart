import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildSectionTitle('App Info'),
            _buildSectionContent('This app converts WEBM files to MP4.'),
            _buildDivider(),
            _buildSectionTitle('Instructions'),
            _buildSectionContent('1. Pick one or multiple WEBM files.\n'
                '2. Click the "Convert" button to start the conversion.'),
            _buildDivider(),
            _buildSectionTitle('Developer Info'),
            _buildSectionContent('Developer: [Your Name]\n'
                'GitHub: [Your GitHub Link]\n'
                'Twitter: [Your Twitter Link]'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(content),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.black,
      height: 20,
      thickness: 2,
    );
  }
}
