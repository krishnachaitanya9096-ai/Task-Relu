abstract class LibraryEvent {}

class LoadTracks extends LibraryEvent {}

class LoadMoreTracks extends LibraryEvent {}

class SearchTracks extends LibraryEvent {
  final String query;
  SearchTracks(this.query);
}