import 'package:flutter/foundation.dart';
import '../SpotifyService.dart';

class SpotifyAuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool isLoading = false;

  /// Called on app start
  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    await SpotifyService.initializeSession();

    if (SpotifyService.accessToken != null) {
      _isAuthenticated = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Login user
  Future<void> login() async {
    isLoading = true;
    notifyListeners();

    await SpotifyService.authenticate();

    if (SpotifyService.accessToken != null) {
      _isAuthenticated = true;
    }

    isLoading = false;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    await SpotifyService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
