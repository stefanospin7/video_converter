
import 'dart:io';
class CustomAudioPlayer {
  static bool muteAudio = false; // Global mute setting

  // Method to play audio using ffplay (FFmpeg)
  static Future<void> playAudio(String filePath) async {
    if (muteAudio) {
      print("Audio is muted. Skipping audio: $filePath");
      return; // Skip playing audio if mute is enabled
    }

    try {
      // Path to the ffplay executable (ensure ffplay is available in the system path)
      String ffplayPath = 'ffplay';

      // Command arguments for ffplay
      List<String> arguments = [
        '-nodisp',           // No video display
        '-autoexit',         // Auto exit when finished playing
        '-volume', '100',    // Set volume level (0-100)
        filePath,            // Input file
      ];

      // Start the FFmpeg process to play the audio with ffplay
      final process = await Process.start(ffplayPath, arguments);

      // Capture stderr to handle any errors
      process.stderr.listen((data) {
        print('Error from ffplay: ${String.fromCharCodes(data)}');
      });

      // Wait for the process to complete
      await process.exitCode;
    } catch (e) {
      print("Error occurred while playing audio with ffplay: $e");
    }
  }

  // Method to stop audio - Not applicable here, as ffplay doesn't allow stopping in the middle
  static Future<void> stopAudio() async {
    print("Stop functionality is not available with ffplay command.");
  }

  // Method to pause audio - Not applicable with ffplay directly
  static Future<void> pauseAudio() async {
    print("Pause functionality is not available with ffplay command.");
  }

  // Dispose method to release resources - Nothing to dispose for ffplay
  static Future<void> dispose() async {
    print("No resources to dispose for ffplay.");
  }
}
