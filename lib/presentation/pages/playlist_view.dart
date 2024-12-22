import 'package:flutter/material.dart';
import 'package:music_v2/domain/entities/playlists.dart';

class PlaylistView extends StatefulWidget {
  final Playlist playlist;
  const PlaylistView({super.key, required this.playlist});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
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
        title: Text(
          widget.playlist.name,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // TODO: Implement add songs functionality
        //       _showAddSongDialog(context);
        //     },
        //     icon: const Icon(Icons.add, color: Colors.white),
        //   ),
        // ],
      ),
      body: widget.playlist.songs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No songs in this playlist',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // ElevatedButton(
                  //   onPressed: () => _showAddSongDialog(context),
                  //   child: const Text('Add Songs'),
                  // ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.playlist.songs.length,
              itemBuilder: (context, index) {
                final song = widget.playlist.songs[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.music_note,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(song.artist),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDuration(song.duration),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'remove',
                              child: Text('Remove from playlist'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'remove') {
                              setState(() {
                                widget.playlist.removeSong(song);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Implement song playback
                    },
                  ),
                );
              },
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // void _showAddSongDialog(BuildContext context) {
  //   // TODO: Implement add song dialog
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Add Song'),
  //       content: const Text('Song selection functionality to be implemented'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Close'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
