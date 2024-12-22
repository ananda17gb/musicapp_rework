import 'package:music_v2/domain/entities/playlists.dart';
import 'package:music_v2/domain/entities/songs.dart';

class Favorite extends Playlist {
  Favorite({required super.name});

  @override
  void addSong(Song song) {
    if (!songs.contains(song)) {
      songs.add(song);
    }
  }

  @override
  void removeSong(Song song) {
    songs.remove(song);
  }
}
