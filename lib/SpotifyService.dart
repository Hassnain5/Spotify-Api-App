import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:spotify_api_app/Consts/Consts.dart';
import 'SpotifyTokenStorage.dart';

class SpotifyService {
  static const String clientId = Consts.clientId;
  static const String clientSecret = Consts.clientSecret;
  static const String redirectUri = 'spotifyapiapp://callback';
  static const List<String> scopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
  ];

  static String? accessToken;
  static String? refreshToken;
  static DateTime? expiryDate;

  static final SpotifyOAuth2Client _client = SpotifyOAuth2Client(
    customUriScheme: 'spotifyapiapp',
    redirectUri: redirectUri,
  );

  static final OAuth2Helper _helper = OAuth2Helper(
    _client,
    clientId: clientId,
    clientSecret: clientSecret,
    scopes: scopes,
  );

  //Authenticate user and save tokens
  static Future<void> authenticate() async {
    try {
      final token = await _helper.getToken();
      if (token != null) {
        accessToken = token.accessToken;
        refreshToken = token.refreshToken;
        expiryDate =
            DateTime.now().add(Duration(seconds: token.expiresIn ?? 3600));

        await SpotifyTokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiryDate: expiryDate,
        );

        print("Spotify Access Token saved successfully!");
      }
    } catch (e) {
      print("Spotify Auth Error: $e");
    }
  }

  // Load tokens and refresh if expired
  static Future<void> initializeSession() async {
    final tokens = await SpotifyTokenStorage.loadTokens();
    accessToken = tokens['accessToken'];
    refreshToken = tokens['refreshToken'];
    expiryDate = tokens['expiryDate'];

    if (accessToken != null && refreshToken != null) {
      if (expiryDate != null && DateTime.now().isAfter(expiryDate!)) {
        await refreshAccessToken();
      }
    }
  }

  // Refresh Access Token
  static Future<void> refreshAccessToken() async {
    if (refreshToken == null) {
      print("No refresh token found.");
      return;
    }

    try {
      final newToken = await _client.refreshToken(
        refreshToken!,
        clientId: clientId,
        clientSecret: clientSecret,
      );

      accessToken = newToken.accessToken;
      refreshToken = newToken.refreshToken ?? refreshToken;
      expiryDate =
          DateTime.now().add(Duration(seconds: newToken.expiresIn ?? 3600));

      await SpotifyTokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiryDate: expiryDate,
      );

      print("Token refreshed successfully!");
    } catch (e) {
      print("Failed to refresh token: $e");
      await logout();
    }
  }

  static Future<void> logout() async {
    await SpotifyTokenStorage.clearTokens();
    accessToken = null;
    refreshToken = null;
    expiryDate = null;
  }
}
