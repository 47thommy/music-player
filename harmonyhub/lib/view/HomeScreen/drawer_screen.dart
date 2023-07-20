import 'package:zema/view/HomeScreen/Playlist/playlist_screen.dart';

import 'package:flutter/material.dart';
import 'package:zema/view/HomeScreen/Recent/recent_songs.dart';

import 'favorite/favourite_screen.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF121212),
            Color(0xFF292929),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30, left: 20),
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Image(
                    width: 120,
                    image: AssetImage('assets/images/logo1.png'),
                  ),
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.playlist_add_check, color: Colors.white),
                title: const Text('Playlists',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlaylistScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border_outlined,
                    color: Colors.white),
                title: const Text(
                  'Favorites',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouriteScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.white),
                title: const Text(
                  'Recently Played',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentlyPlayed(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
