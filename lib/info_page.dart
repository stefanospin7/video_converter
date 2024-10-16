import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class InfoPage extends StatelessWidget {
  final String appVersion = '1.0.1';

  const InfoPage({super.key}); // Define your app version here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 200) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App version:'),
                  _buildVersionLabel(),
                ],
              );
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('App version:'),
                  const SizedBox(width: 8),
                  _buildVersionLabel(),
                ],
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('App Info'),
              _buildSectionContent(
                  'This is an open-source app written in Flutter that currently allows you to convert webm files to mp4 files. This functionality is made possible by ffmpeg, without which the app would not work. While I know this can be done via the terminal, I wanted to contribute to the open-source world by providing a graphical app to do it :) You can take a look and contribute to the code here on GitHub:'),
              _buildLink('GitHub Repo',
                  'https://github.com/stefanospin7/video_converter'),
              _buildLink(
                  'For more information on ffmpeg', 'https://ffmpeg.org/'),
              _buildDivider(),

              // New section for Version Info
              _buildSectionTitle('Version 1.0.1'),
              _buildSectionContent(
                  'This is the second updated version of this app, bringing numerous improvements and bug fixes, including:\n\n'
                  '- A conversion speed approximately 12x faster than the previous version.\n'
                  '- Better resulting video quality (both in fps and frame resolution).\n'
                  '- Fixes the conversion crash bug for large files.\n'
                  '- A modern, darker graphic redesign to reduce eye strain.\n'
                  '- Fixed windows resizing bugs.\n'
                  '- Added a handler to manage the installation of ffmpeg directly from the app.\n'
                  '- The creation of a new icon!\n'),

              _buildDivider(),
              _buildSectionTitle('Instructions'),
              _buildSectionContent(
                  'Currently, this app is designed to work only on Linux distributions, specifically Debian or Red Hat based distros. You will need to install ffmpeg if you haven\'t already done so (sudo apt install ffmpeg), then launch the app, click on "pick file", select one or more files from the file manager, click "convert", and wait for the loader to finish without closing the app. Enjoy your converted files, which will be located in the same folder as the selected files :)'),
              _buildDivider(),
              _buildSectionTitle('Developer Info'),
              _buildSectionContent(
                  'My name is Stefano Spinelli and I work as an iOS developer (Swift). In my free time, I enjoy making music and programming in various languages. If you want to contact me, get more information, give me advice, insult me for my code, or collaborate on the app, you can do so on Twitter via DMs. I also provide my GitHub if you want to follow me:'),
              _buildLink('My GitHub page', 'https://github.com/stefanospin7'),
              _buildLink('X(Twitter)', 'https://twitter.com/stefanospinel15'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFBB86FC), // Choose your desired color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        appVersion,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white, // Change text color to white for dark mode
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        content,
        style:
            const TextStyle(color: Colors.white70), // Lighten the content text
      ),
    );
  }

  Widget _buildLink(String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
            color: Colors.white70), // Change divider color for dark mode
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: GestureDetector(
            onTap: () async {
              // Open the URL in the default browser
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFBB86FC), // Light purple for links
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white70, // Change divider color for dark mode
      height: 20,
      thickness: 1,
    );
  }
}
