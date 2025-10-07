
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';
import 'Providers/SpotifyAuthProvider.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spotify Login")),
      body: Consumer<SpotifyAuthProvider>(

        builder: (context, provider, _) {
          if (provider.isAuthenticated) {
              Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            });
          }
          return Center(
            child: provider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: provider.login,
              child: const Text("Login with Spotify"),
            ),
          );
        }
      ),
    );
  }
}
