import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ApiService api;

  DetailsBloc(this.api) : super(const DetailsState()) {
    on<LoadDetails>(_loadDetails);
  }

  Future<void> _loadDetails(
      LoadDetails event, Emitter<DetailsState> emit) async {
    if (!await api.hasInternet()) {
      emit(state.copyWith(error: "NO INTERNET CONNECTION"));
      return;
    }
    emit(state.copyWith(isLoading: true));

    final details = await api.fetchTrackDetails(event.trackId);

    final lyrics = await api.fetchLyrics(
      track: event.title,
      artist: event.artist,
      album: event.album,
      duration: event.duration,
    );

    emit(state.copyWith(
      isLoading: false,
      details: details,
      lyrics: lyrics,
    ));
  }
}