import 'dart:io';
import 'package:music_v2/domain/entities/songs_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:uuid/uuid.dart';
import 'package:music_v2/domain/entities/songs.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SongScanner {
  static const _supportedExtensions = ['.mp3', '.m4a', '.aac', '.wav'];

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        var status = await Permission.storage.status;
        if (status.isGranted) return true;
        status = await Permission.storage.request();
        return status.isGranted;
      } else {
        var status = await Permission.audio.status;
        if (status.isGranted) return true;
        status = await Permission.audio.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      var status = await Permission.storage.status;
      if (status.isGranted) return true;
      status = await Permission.storage.request();
      return status.isGranted;
    } else {
      return true; // Assume permission is granted on other platforms
    }
  }

  Future<List<Song>> scanDeviceForSongs(SongManager songManager) async {
    try {
      if (!await requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      List<Song> discoveredSongs = [];
      List<Directory> searchPaths = await _getSearchDirectories();

      for (Directory dir in searchPaths) {
        if (await dir.exists()) {
          try {
            await for (FileSystemEntity entity in dir.list(recursive: true)) {
              if (entity is File && _isSupportedAudioFile(entity.path)) {
                try {
                  Song? song = await _createSongFromFile(entity.path);
                  if (song != null) {
                    discoveredSongs.add(song);
                    songManager.addSong(song);
                  }
                } catch (e) {
                  print('Error processing file ${entity.path}: $e');
                }
              }
            }
          } catch (e) {
            print('Error accessing directory ${dir.path}: $e');
          }
        }
      }

      return discoveredSongs;
    } catch (e) {
      print('Error in scanDeviceForSongs: $e');
      rethrow;
    }
  }

  Future<List<Directory>> _getSearchDirectories() async {
    List<Directory> directories = [];

    if (Platform.isAndroid) {
      // Common Android music directories
      directories.addAll([
        Directory('/storage/emulated/0/Music'),
        Directory('/storage/emulated/0/Download'),
      ]);

      // Get external storage directories
      final List<Directory>? extDirs = await getExternalStorageDirectories();
      if (extDirs != null) {
        directories.addAll(extDirs);
      }
    } else if (Platform.isIOS) {
      // iOS documents directory
      final Directory docDir = await getApplicationDocumentsDirectory();
      directories.add(docDir);
    }

    return directories;
  }

  bool _isSupportedAudioFile(String path) {
    final lowercasePath = path.toLowerCase();
    return _supportedExtensions.any((ext) => lowercasePath.endsWith(ext));
  }

  Future<Song?> _createSongFromFile(String filePath) async {
    try {
      final metadata = await MetadataRetriever.fromFile(File(filePath));

      final title =
          metadata.trackName ?? _getFileNameWithoutExtension(filePath);
      final artist = metadata.authorName ?? 'Unknown Artist';
      final duration = Duration(milliseconds: metadata.trackDuration ?? 0);

      // Generate a unique ID for the song
      final uuid = const Uuid().v4();

      return Song(
        id: uuid,
        title: title,
        artist: artist,
        duration: duration,
        filePath: filePath,
        cover: metadata.albumArt != null
            ? 'data:image/jpeg;base64,${metadata.albumArt}'
            : 'assets/default_cover.png',
      );
    } catch (e) {
      print('Error extracting metadata from $filePath: $e');
      return null;
    }
  }

  String _getFileNameWithoutExtension(String filePath) {
    final fileName = filePath.split('/').last;
    try {
      return fileName.substring(0, fileName.lastIndexOf('.'));
    } catch (e) {
      return fileName; // Handle files without extensions
    }
  }
}
