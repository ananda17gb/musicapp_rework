class Song {
  final String _id;
  final String _title;
  final String _artist;
  final Duration _duration;
  final String _cover;
  final String _filePath;

  Song({
    required String id,
    required String title,
    required String artist,
    required Duration duration,
    required String filePath,
    required String cover,
  })  : _id = id,
        _title = title,
        _artist = artist,
        _duration = duration,
        _filePath = filePath,
        _cover = cover;

  String get id => _id;
  String get title => _title;
  String get artist => _artist;
  Duration get duration => _duration;
  String get filePath => _filePath;
  String get cover => _cover;
}
