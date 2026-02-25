import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/library/library_bloc.dart';
import '../bloc/library/library_event.dart';
import '../bloc/library/library_state.dart';
import '../models/track_model.dart';
import 'details_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<LibraryBloc>().add(LoadTracks());

    _controller.addListener(() {
      if (_controller.position.pixels ==
          _controller.position.maxScrollExtent) {
        context.read<LibraryBloc>().add(LoadMoreTracks());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Music Library")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                context.read<LibraryBloc>().add(
                      SearchTracks(value),
                    );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                if (state.isLoading &&
                    state.tracks.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _controller,
                  itemCount: state.tracks.length,
                  itemBuilder: (context, index) {
                    final Data track =
                        state.tracks[index];

                    return ListTile(
                      title: Text(track.title ?? ""),
                      subtitle:
                          Text(track.artist?.name ?? ""),
                      trailing:
                          Text(track.id?.toString() ?? ""),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(
                              track: track,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}