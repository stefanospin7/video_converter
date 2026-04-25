import 'package:flutter/material.dart';
import 'package:webm_converter/app_links.dart';

class InfoPage extends StatelessWidget {
  final String appVersion = '1.0.4';

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
              _buildSectionTitle('Important Notice'),
              _buildSectionContent(
                'WEBM Converter will no longer be actively maintained. It was used as the base for Armour Converter, which is now the recommended app for future updates, better efficiency, and more recent features.',
              ),
              _buildSectionContent(
                'If you still need a simple WebM to MP4 workflow you can keep using this app, but new development will continue on Armour Converter. Armour Converter is available on Snap Store for both AMD64 and ARM64 systems.',
              ),
              _buildLink(
                context,
                'Snap Store: Download Armour Converter',
                armourConverterUrl,
              ),
              _buildDivider(),
              _buildSectionTitle('App Info'),
              _buildSectionContent(
                  'This is an open-source app written in Flutter that currently allows you to convert webm files to mp4 files. This functionality is made possible by ffmpeg, without which the app would not work. While I know this can be done via the terminal, I wanted to contribute to the open-source world by providing a graphical app to do it :) You can take a look and contribute to the code here on GitHub:'),
              _buildLink(context, 'GitHub Repo',
                  'https://github.com/stefanospin7/webm_converter'),
              _buildLink(context, 'For more information on ffmpeg',
                  'https://ffmpeg.org/'),
              _buildDivider(),
              _buildSectionTitle('Armour Converter'),
              _buildSectionContent(
                'A powerful multimedia converter for video, audio and images. Armour Converter is a fast, more efficient and easy-to-use multimedia converter built with Flutter, available for both AMD64 and ARM64 on Snap Store.',
              ),
              _buildSectionContent(
                'Features:\n\n'
                '- Video to Video: MP4, MKV, AVI, WebM, MOV\n'
                '- Video to Audio: Extract audio from videos\n'
                '- Audio to Audio: MP3, AAC, WAV, FLAC, OPUS, OGG\n'
                '- Image to Image: PNG, JPG, WebP, BMP, TIFF\n'
                '- Batch conversion support\n'
                '- Quality and FPS settings\n'
                '- Dark/Light theme\n'
                '- English and Italian languages',
              ),
              _buildLink(
                context,
                'Snap Store: Open Armour Converter',
                armourConverterUrl,
              ),
              _buildDivider(),
              _buildSectionTitle('Version 1.0.4'),
              _buildSectionContent(
                  'This release turns WEBM Converter into a migration build for Armour Converter. It adds a startup notice, a direct call-to-action in the top bar, and updated in-app information to guide users to the newer, more efficient app with broader and more up-to-date features.'),
              _buildDivider(),
              _buildSectionTitle('Instructions'),
              _buildSectionContent(
                  'Currently, this app is designed to work only on Linux distributions, specifically Debian or Red Hat based distros. You will need to install ffmpeg if you haven\'t already done so (sudo apt install ffmpeg), then launch the app, click on "pick file", select one or more files from the file manager, click "convert", and wait for the loader to finish without closing the app. Enjoy your converted files, which will be located in the same folder as the selected files :)'),
              _buildDivider(),
              _buildSectionTitle('Developer Info'),
              _buildSectionContent(
                  'My name is Stefano Spinelli and I work as an iOS developer (Swift). In my free time, I enjoy making music and programming in various languages. If you want to contact me, get more information, give me advice, insult me for my code, or collaborate on the app, you can do so on Twitter via DMs. I also provide my GitHub if you want to follow me:'),
              _buildLink(
                  context, 'My GitHub page', 'https://github.com/stefanospin7'),
              _buildLink(
                  context, 'X(Twitter)', 'https://twitter.com/stefanospinel15'),
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

  Widget _buildLink(BuildContext context, String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
            color: Colors.white70), // Change divider color for dark mode
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: GestureDetector(
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final opened = await openExternalLink(url);
              if (!opened && context.mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Could not launch $url'),
                  ),
                );
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
