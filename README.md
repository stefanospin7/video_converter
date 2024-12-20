# WEBM converter v 1.0.2
<img src="./utils/photos/icon_512p.png" alt="icon" width="300" />


This app currently allows you to convert webm files to mp4 files in linux. This functionality is made possible by ffmpeg, without which the app would not work. While I know this can be done via the terminal, I wanted to contribute to the open-source world by providing a graphical app to do it :)

## About v 1.0.2

This is the second updated version of this app, bringing numerous improvements and bug fixes, including:
1. Allowing users to choose the quality of the export.
2. Allowing users to select the FPS for the exports.
3. Added drag-and-drop functionality for a smoother experience.
4. Added the option to delete items after selection.
5. Updated the UI with some graphical enhancements.
6. Improved overall app functionality and stability.




## Installation

The latest version of this app is available on the Snap Store:
https://snapcraft.io/webm-converter

![Screenshot 1](./utils/photos/screenshot00.png)
![screenshot 2](./utils/photos/screenshot04b.png)
![Screenshot 3](./utils/photos/screenshot02b.png)


## Prerequisites (for Non-Snap Installation)

Before using the app, ensure that FFmpeg is installed on your system. If it is not installed, you can add it using the package manager specific to your Linux distribution. For example:

```bash
sudo apt-get update
sudo apt-get install ffmpeg
```


## TODO
1. Make the app standalone without the need for FFmpeg installation (potentially using the Flutter FFmpeg package).
2. Add support for more video file types for conversion.
3. Extend the app to be compatible with multiple operating systems (currently only Debian or Red Hat based distros).
4. Add conversion percentage of the files.
5. Add user feedbacks


Feel free to contribute by addressing these TODO items or by submitting new features and enhancements. Your contributions are highly appreciated!

