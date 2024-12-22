import 'package:music_v2/domain/entities/playlists.dart';

class PlaylistManager {
  List<Playlist> playlists = [];

  void addPlaylist(Playlist playlist) {
    // Check if a playlist with the same name already exists
    if (!playlists
        .any((existingPlaylist) => existingPlaylist.name == playlist.name)) {
      playlists.add(playlist);
    }
  }

  void removePlaylist(Playlist playlist) {
    playlists.remove(playlist);
  }

  Playlist? findPlaylistByName(String name) {
    try {
      return playlists.firstWhere((playlist) => playlist.name == name);
    } catch (e) {
      return null;
    }
  }
}
