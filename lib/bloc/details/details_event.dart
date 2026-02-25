abstract class DetailsEvent {}

class LoadDetails extends DetailsEvent {
  final int trackId;
  final String title;
  final String artist;
  final String album;
  final int duration;

  LoadDetails({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
  });
}