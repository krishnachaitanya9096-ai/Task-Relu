class TrackModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int duration;

  TrackModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'],
      title: json['title'] ?? "",
      artist: json['artist']['name'] ?? "",
      album: json['album']['title'] ?? "",
      duration: json['duration'] ?? 0,
    );
  }
}