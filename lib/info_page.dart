import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoPage extends StatelessWidget {
  final String appVersion = '1.0.0'; // Define your app version here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('App version:'),
            SizedBox(width: 8), // Add some space between 'Info' and version
            _buildVersionLabel(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildSectionTitle('App Info'),
            _buildSectionContent('This is an open-source app written in Flutter that currently allows you to convert webm files to mp4 files. This functionality is made possible by ffmpeg, without which the app would not work. While I know this can be done via the terminal, I wanted to contribute to the open-source world by providing a graphical app to do it :) You can take a look and contribute to the code here on GitHub:'),
            _buildLinkWithCopyButton(context, 'GitHub Repo', 'https://github.com/'),
            _buildLinkWithCopyButton(context, 'For more information on ffmpeg', 'https://ffmpeg.org/'),
            _buildDivider(),
            _buildSectionTitle('Instructions'),
            _buildSectionContent('Currently, this app is designed to work only on Linux distributions, specifically Debian. You will need to install ffmpeg if you haven\'t already done so (sudo apt install ffmpeg), then launch the app, click on "pick file", select one or more files from the file manager, click "convert", and wait for the loader to finish without closing the app. Enjoy your converted files, which will be located in the same folder as the selected files :)'),
            _buildDivider(),
            _buildSectionTitle('Developer Info'),
            _buildSectionContent('My name is Stefano Spinelli and I work as an iOS developer (Swift). In my free time, I enjoy making music and programming in various languages. If you want to contact me, get more information, give me advice, insult me for my code, or collaborate on the app, you can do so on Twitter via DMs. I also provide my GitHub if you want to follow me:'),
            _buildLinkWithCopyButton(context, 'My GitHub page', 'https://github.com/stefanospin7'),
            _buildLinkWithCopyButton(context, 'X(Twitter)', 'https://twitter.com/stefanospinel15'),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent, // Choose your desired color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$appVersion',
        style: TextStyle(
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

  Widget _buildLinkWithCopyButton(BuildContext context, String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Open the URL in browser
                },
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  _copyToClipboard(url);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link copied to clipboard')));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.black,
      height: 20,
      thickness: 2,
    );
  }
}
