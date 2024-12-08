# WEBM converter v 1.0.1
<img src="./utils/photos/icon_512p.png" alt="icon" width="300" />


This app currently allows you to convert webm files to mp4 files in linux. This functionality is made possible by ffmpeg, without which the app would not work. While I know this can be done via the terminal, I wanted to contribute to the open-source world by providing a graphical app to do it :)

## About v 1.0.1

This is the second updated version of this app, bringing numerous improvements and bug fixes, including:
1. A conversion speed approximately 12x faster than the previous version.
2. Better resulting video quality (both in fps and frame resolution).
3. Fixes the conversion crash bug for large files.
4. A modern, darker graphic redesign to reduce eye strain.
5. Fixed windows resizing bugs.




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
7. Add quality selection and fps selection.
8. Add user feedbacks


Feel free to contribute by addressing these TODO items or by submitting new features and enhancements. Your contributions are highly appreciated!

