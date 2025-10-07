import 'dart:convert';
import 'package:http/http.dart' as http;
import '../SpotifyService.dart';

class SpotifyDataService {
  static Future<List<Map<String, dynamic>>> searchSongs(String query) async {
    if (SpotifyService.accessToken == null) {
      throw Exception("User not authenticated");
    }

    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/search?q=$query&type=track&limit=10"),
      headers: {
        "Authorization": "Bearer ${SpotifyService.accessToken}",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['tracks']['items'] as List<dynamic>;

      return tracks.map((track) {
        return {
          "name": track["name"],
          "artist": track["artists"][0]["name"],
          "album": track["album"]["name"],
          "image": track["album"]["images"].isNotEmpty
              ? track["album"]["images"][0]["url"]
              : null,
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch songs: ${response.statusCode}");
    }
  }
}
