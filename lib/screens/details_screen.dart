import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/details/details_bloc.dart';
import '../bloc/details/details_event.dart';
import '../bloc/details/details_state.dart';
import '../models/track_model.dart';
import '../services/api_service.dart';

class DetailsScreen extends StatelessWidget {
  final Data track;

  const DetailsScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DetailsBloc(context.read<ApiService>())
            ..add(
              LoadDetails(
                trackId: track.id??0,
                title: track.title??'',
                artist: track.artist?.name??'',
                album: track.album?.title??'',
                duration: track.duration??0,
              ),
            ),
      child: Scaffold(
        appBar: AppBar(title: Text(track.title??'')),
        body: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            if (state.isLoading) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text("Artist: ${track.artist}"),
                  const SizedBox(height: 10),
                  Text("Album: ${track.album}"),
                  const SizedBox(height: 20),
                  const Text("Lyrics:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(state.lyrics ?? "No Lyrics"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}