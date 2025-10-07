import 'package:flutter/foundation.dart';
import '../SpotifyDataService.dart';

class SearchSongProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _songs = [];
  bool _isLoading = false;
  String _error = '';

  List<Map<String, dynamic>> get songs => _songs;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _songs = await SpotifyDataService.searchSongs(query);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
