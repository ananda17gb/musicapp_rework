// import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_v2/domain/entities/songs.dart';

class Player {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? currentSong;
  Function(bool)? onPlaybackStateChanged;
  bool _isPlaying = false;

  Player() {
    // Listen to playback completion
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      onPlaybackStateChanged?.call(false);
    });

    // Listen to playback state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
      onPlaybackStateChanged?.call(_isPlaying);
    });
  }

  Future<void> play(Song song) async {
    try {
      print('Attempting to play song: ${song.title}');
      print('File path: ${song.filePath}');

      // Stop current playback if any
      if (_isPlaying) {
        await _audioPlayer.stop();
      }

      if (song.filePath.isEmpty) {
        print('Invalid file path');
        return;
      }

      // Set source and play
      await _audioPlayer.play(DeviceFileSource(song.filePath));
      await _audioPlayer.resume();

      currentSong = song;
      _isPlaying = true;
      onPlaybackStateChanged?.call(true);

      print('Successfully started playback');
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      onPlaybackStateChanged?.call(false);
      rethrow; // Rethrow to handle in UI if needed
    }
  }

  Future<void> pause() async {
    try {
      print('Attempting to pause');
      await _audioPlayer.pause();
      _isPlaying = false;
      onPlaybackStateChanged?.call(false);
      print('Successfully paused');
    } catch (e) {
      print('Error pausing: $e');
    }
  }

  Future<void> resume() async {
    try {
      print('Attempting to resume');
      await _audioPlayer.resume();
      _isPlaying = true;
      onPlaybackStateChanged?.call(true);
      print('Successfully resumed');
    } catch (e) {
      print('Error resuming: $e');
    }
  }

  Future<void> stop() async {
    try {
      print('Attempting to stop');
      await _audioPlayer.stop();
      _isPlaying = false;
      onPlaybackStateChanged?.call(false);
      print('Successfully stopped');
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      print('Successfully seeked to: $position');
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    onPlaybackStateChanged = null;
    print('Player disposed');
  }

  bool get isPlaying => _isPlaying;

  // Future<void> skipToNext() async {
  //   await _audioPlayer.seekToNext();
  //   print("Playing the next song");
  // }

  // Future<void> seekToPrevious() async {
  //   await _audioPlayer.seekToPrevious();
  //   print("Playing the previous song");
  // }
}
