import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final ApiService api;

  int index = 0;
  final int limit = 50;
  String currentQuery = "a";

  LibraryBloc(this.api) : super(const LibraryState()) {
    on<LoadTracks>(_loadInitial);
    on<LoadMoreTracks>(_loadMore);
    on<SearchTracks>(_search);
  }

  Future<void> _loadInitial(
      LoadTracks event, Emitter<LibraryState> emit) async {
    if (!await api.hasInternet()) {
      emit(state.copyWith(error: "NO INTERNET CONNECTION"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    index = 0;

    final tracks = await api.fetchTracks(
      query: currentQuery,
      index: index,
      limit: limit,
    );

    index += limit;

    emit(state.copyWith(
      tracks: tracks,
      isLoading: false,
    ));
  }

  Future<void> _loadMore(
      LoadMoreTracks event, Emitter<LibraryState> emit) async {
    if (state.hasReachedMax) return;

    final tracks = await api.fetchTracks(
      query: currentQuery,
      index: index,
      limit: limit,
    );

    if (tracks.isEmpty) {
      emit(state.copyWith(hasReachedMax: true));
    } else {
      index += limit;
      emit(state.copyWith(
        tracks: [...state.tracks, ...tracks],
      ));
    }
  }

  void _search(SearchTracks event, Emitter<LibraryState> emit) {
    currentQuery = event.query;
    add(LoadTracks());
  }
}