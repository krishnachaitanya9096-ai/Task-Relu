import 'package:equatable/equatable.dart';
import '../../models/track_model.dart';

class LibraryState extends Equatable {
  final List<Data> tracks;
  final bool isLoading;
  final bool hasReachedMax;
  final String? error;

  const LibraryState({
    this.tracks = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.error,
  });

  LibraryState copyWith({
    List<Data>? tracks,
    bool? isLoading,
    bool? hasReachedMax,
    String? error,
  }) {
    return LibraryState(
      tracks: tracks ?? this.tracks,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
    );
  }

  @override
  List<Object?> get props => [tracks, isLoading, hasReachedMax, error];
}