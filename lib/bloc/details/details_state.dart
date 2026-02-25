import 'package:equatable/equatable.dart';

class DetailsState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? details;
  final String? lyrics;
  final String? error;

  const DetailsState({
    this.isLoading = false,
    this.details,
    this.lyrics,
    this.error,
  });

  DetailsState copyWith({
    bool? isLoading,
    Map<String, dynamic>? details,
    String? lyrics,
    String? error,
  }) {
    return DetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      lyrics: lyrics ?? this.lyrics,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, details, lyrics, error];
}