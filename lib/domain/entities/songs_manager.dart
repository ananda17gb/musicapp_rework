import 'package:music_v2/domain/entities/song_scanner.dart';
import 'package:music_v2/domain/entities/songs.dart';

class SongManager {
  List<Song> songs = [];
  late final SongScanner _songScanner;

  SongManager() {
    _songScanner = SongScanner();
  }

  void addSong(Song song) {
    if (!songs.any((s) => s.id == song.id)) {
      songs.add(song);
    }
  }

  void removeSong(Song song) {
    songs.remove(song);
  }

  List<Song> searchSongs(String query) {
    return songs
        .where((song) =>
            song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Song>> scanForSongs() async {
    try {
      return await _songScanner.scanDeviceForSongs(this);
    } catch (e) {
      print('Error in scanForSongs: $e');
      rethrow;
    }
  }
}
