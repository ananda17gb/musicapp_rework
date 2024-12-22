//2 DESIGN
import 'package:flutter/material.dart';
import 'package:music_v2/domain/entities/songs.dart';
import 'package:music_v2/domain/entities/songs_manager.dart';
import 'package:music_v2/domain/entities/player.dart';
import 'package:music_v2/presentation/widgets/song_cards.dart';
import 'package:music_v2/presentation/widgets/PlayingBar.dart';

class MusicScreen extends StatefulWidget {
  final SongManager songManager;
  const MusicScreen({super.key, required this.songManager});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final TextEditingController _searchController = TextEditingController();
  // final Player _player = Player();
  late final Player _player;

  Song? _currentSong;
  bool _isPlaying = false;
  bool _isSongSelected = false;
  String _currentSongTitle = "Song Title";
  String _currentArtistName = "Artist Name";
  String _currentSongId = "";
  bool _isScanning = false;

  List<Song> _displayedSongs = [];

  @override
  void initState() {
    super.initState();
    _displayedSongs = widget.songManager.songs;
    _player = Player();
    _player.onPlaybackStateChanged = _onPlaybackStateChanged;
  }

  void _onPlaybackStateChanged(bool isPlaying) {
    if (mounted) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  void _playSong(Song song) async {
    if (_currentSong?.id == song.id) {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.resume();
      }
    } else {
      setState(() {
        _currentSong = song;
        _isPlaying = true;
        _isSongSelected = true;
        _currentSongTitle = song.title;
        _currentArtistName = song.artist;
        _currentSongId = song.id;
      });
      await _player.play(song);
    }
  }

  void _searchSongs(String query) {
    setState(() {
      _displayedSongs = widget.songManager.searchSongs(query);
    });
  }

  Future<void> _scanForSongs() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
    });

    try {
      await widget.songManager.scanForSongs();

      setState(() {
        _displayedSongs = widget.songManager.songs;
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${widget.songManager.songs.length} songs'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning songs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose(); // Make sure Player class has a dispose method
    _searchController.dispose();
    super.dispose();
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
          'Songs',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _scanForSongs,
            icon: _isScanning
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.upload),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _searchController,
                onChanged: _searchSongs,
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
                              _displayedSongs = widget.songManager.songs;
                            });
                          },
                        )
                      : null,
                  hintText: "Find Your Songs",
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
                itemCount: _displayedSongs.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  Song song = _displayedSongs[index];
                  return SongsCards(
                    song: song,
                    isCurrentlyPlaying: _currentSongId == song.id,
                    onPlay: () => _playSong(song),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: _isSongSelected,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: PlayingBar(
            songTitle: _currentSongTitle,
            artistName: _currentArtistName,
            isPlaying: _isPlaying,
            onPlayPause: () {
              if (_isPlaying) {
                _player.pause();
                setState(() => _isPlaying = false);
              } else {
                _player.play(_currentSong!);
                setState(() => _isPlaying = true);
              }
            },
            onClose: () {
              _player.stop();
              setState(() {
                _isSongSelected = false;
                _isPlaying = false;
                _currentSong = null;
                _currentSongTitle = "Song Title";
                _currentArtistName = "Artist Name";
                _currentSongId = "";
              });
            },
          ),
        ),
      ),
    );
  }
}
