import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/SearchSongProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchSongProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Spotify Song Search")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search for a song...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (query) {
                provider.search(query);
              },
            ),
            const SizedBox(height: 16),

            // 🌀 Loading Indicator
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.error.isNotEmpty)
              Text(provider.error, style: const TextStyle(color: Colors.red))
            else if (provider.songs.isEmpty)
                const Text("No results yet. Try searching something!")
              else
              // 🎵 List of Songs
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.songs.length,
                    itemBuilder: (context, index) {
                      final song = provider.songs[index];
                      return Card(
                        child: ListTile(
                          leading: song["image"] != null
                              ? Image.network(song["image"], width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.music_note, size: 40),
                          title: Text(song["name"]),
                          subtitle: Text("${song["artist"]} • ${song["album"]}"),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
