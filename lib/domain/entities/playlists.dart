import 'package:music_v2/domain/entities/songs.dart';

class Playlist {
  String name;
  List<Song> songs;

  Playlist({
    required this.name,
    this.songs = const [],
  });

  void addSong(Song song) {
    if (!songs.contains(song)) {
      songs.add(song);
    }
  }

  void removeSong(Song song) {
    songs.remove(song);
  }
}
