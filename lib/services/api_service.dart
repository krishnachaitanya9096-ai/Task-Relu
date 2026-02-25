
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/track_model.dart';

class ApiService {
  late final Dio dio;
  late PersistCookieJar cookieJar;

  ApiService() {
    dio = Dio(
      BaseOptions(
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36",
          "Accept": "application/json",
        },
        followRedirects: true,
        validateStatus: (status) => status! < 500,
      ),
    );

    _initCookies();
  }

  Future<void> _initCookies() async {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(
      storage: FileStorage("${dir.path}/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<List<TrackModel>> fetchTracks({
    required String query,
    required int index,
    required int limit,
  }) async {
    try {

      await dio.get("https://www.deezer.com/");

      final response = await dio.get(
        'https://api.deezer.com/search/track',
        queryParameters: {
          'q': query,
          'index': index,
          'limit': limit,
        },
      );

      final List data = response.data['data'] ?? [];

      print("TRACK COUNT: ${data.length}");

      return data.map((e) => TrackModel.fromJson(e)).toList();
    } catch (e) {
      print("ERROR: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchTrackDetails(int id) async {
    try {
      final response =
          await dio.get('https://api.deezer.com/track/$id');
      return response.data ?? {};
    } catch (e) {
      print("ERROR FETCHING DETAILS: $e");
      return {};
    }
  }

  Future<String> fetchLyrics({
    required String track,
    required String artist,
    required String album,
    required int duration,
  }) async {
    try {
      final response = await dio.get(
        'https://lrclib.net/api/get-cached',
        queryParameters: {
          'track_name': track,
          'artist_name': artist,
          'album_name': album,
          'duration': duration,
        },
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['plainLyrics'] != null) {
        return response.data['plainLyrics'];
      }

      return "No Lyrics Found";
    } catch (e) {
      print("ERROR FETCHING LYRICS: $e");
      return "No Lyrics Found";
    }
  }
}