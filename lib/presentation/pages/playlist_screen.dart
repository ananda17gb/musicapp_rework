import 'package:flutter/material.dart';
import 'package:music_v2/domain/entities/favorite.dart';
import 'package:music_v2/domain/entities/playlists.dart';
import 'package:music_v2/domain/entities/playlists_manager.dart';
import 'package:music_v2/presentation/widgets/playlist_cards.dart';
import 'package:music_v2/presentation/widgets/PlayingBar.dart';
import 'package:music_v2/presentation/pages/playlist_view.dart';

class PlaylistScreen extends StatefulWidget {
  final PlaylistManager? playlistManager;
  const PlaylistScreen({super.key, this.playlistManager});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Playlist?> _displayedPlaylists = [];
  PlaylistManager _playlistManager = PlaylistManager();

  @override
  void initState() {
    super.initState();
    if (widget.playlistManager != null) {
      _playlistManager = widget.playlistManager!;
    }
    _displayedPlaylists = _playlistManager.playlists;
  }

  void _searchPlaylists(String query) {
    setState(() {
      // Filter playlists by name
      _displayedPlaylists = _playlistManager.playlists
          .where((playlist) =>
              playlist.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Playlists',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _showAddPlaylistDialog(context);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _searchController,
                onChanged: _searchPlaylists,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _displayedPlaylists = _playlistManager.playlists;
                            });
                          },
                        )
                      : null,
                  hintText: "Find Your Playlist",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _displayedPlaylists.length + 1,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    Favorite favoritePlaylist = Favorite(name: "Favorite");
                    return PlaylistCards(
                      playlist: favoritePlaylist,
                      onTap: () {
                        // TODO: Implement navigate to favorite playlist details
                        _navigateToPlaylistDetails(favoritePlaylist);
                      },
                    );
                  }

                  Playlist? playlist = _displayedPlaylists[index - 1];
                  return playlist != null
                      ? PlaylistCards(
                          playlist: playlist,
                          onTap: () {
                            // TODO: Implement navigate to playlist details
                            _navigateToPlaylistDetails(playlist);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlaylistDialog(BuildContext context) {
    final TextEditingController playlistNameController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(
              hintText: 'Enter playlist name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String playlistName = playlistNameController.text.trim();
                if (playlistName.isNotEmpty) {
                  Playlist newPlaylist = Playlist(name: playlistName);
                  _playlistManager.addPlaylist(newPlaylist);
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPlaylistDetails(Playlist playlist) {
    // TODO: Implement navigation to playlist details screen
    // You might want to create a new screen or pass the playlist to another widget
    // print('Navigate to playlist: ${playlist.name}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlaylistView(playlist: playlist)));
  }
}
