import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LoginScreen.dart';
import 'Providers/SearchSongProvider.dart';
import 'Providers/SpotifyAuthProvider.dart';
import 'SpotifyService.dart';

void main() {
  runApp(const SpotifyAuthApp());
}

class SpotifyAuthApp extends StatelessWidget {
  const SpotifyAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SpotifyAuthProvider()),
          ChangeNotifierProvider(create: (_) => SearchSongProvider()),
        ],
        child: MaterialApp(
      title: 'Spotify Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
        ));
  }
}
