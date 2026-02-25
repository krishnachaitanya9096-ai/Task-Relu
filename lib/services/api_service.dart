import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/track_model.dart';

class ApiService {
  final Dio dio = Dio();

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

 Future<List<Data>> fetchTracks({
  required String query,
  required int index,
  required int limit,
}) async {
  try {
    final response = await dio.get(
      'https://api.deezer.com/search/track',
      queryParameters: {
        'q': query,
        'index': index,
        'limit': limit,
      },
      options: Options(
        headers: {
          "Accept": "application/json",
        },
      ),
    );

    print("STATUS: ${response.statusCode}");
    print("DATA: ${response.data}");


     final trackModel = TrackModel.fromJson(response.data);

  return trackModel.data ?? [];
  } catch (e) {
    print("ERROR: $e");
    rethrow;
  }
}

  Future<Map<String, dynamic>> fetchTrackDetails(int id) async {
    final response =
        await dio.get('https://api.deezer.com/track/$id');
    return response.data;
  }

  Future<String> fetchLyrics({
    required String track,
    required String artist,
    required String album,
    required int duration,
  }) async {
    final response = await dio.get(
      'https://lrclib.net/api/get-cached',
      queryParameters: {
        'track_name': track,
        'artist_name': artist,
        'album_name': album,
        'duration': duration,
      },
    );

    return response.data['plainLyrics'] ?? "No Lyrics Found";
  }
}