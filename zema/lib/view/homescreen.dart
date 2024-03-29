import 'package:zema/controller/get_all_song.dart';

import 'package:zema/view/HomeScreen/drawer_screen.dart' as drawer;

import 'package:zema/view/mini_player.dart';

import 'package:zema/controller/provider/provider.dart';

import 'package:zema/view/search_screen.dart';
import 'package:zema/view/widgets/menu_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:zema/view/MusicPlayer/musicplayer.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../controller/get_recent_controller.dart';
import '../db/favourite_db.dart';

List<SongModel> startSong = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  final bool isFavourite = false;

  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } on Exception {
      log('Error parsing song');
    }
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
    Permission.storage.request;
  }

  final _audioQuery = OnAudioQuery();

  final _audioPlayer = AudioPlayer();

  final List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        centerTitle: true,
        title: const Image(
          image: AssetImage('assets/images/logo1.png'),
          width: 120,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.width * 2.0,
        child: const drawer.NavigationDrawer(),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF121212),
                Color(0xFF292929),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ' All Songs',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<List<SongModel>>(
                        future: _audioQuery.querySongs(
                          sortType: null,
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL,
                          ignoreCase: true,
                        ),
                        builder: (context, item) {
                          if (item.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (item.data!.isEmpty) {
                            return const Center(
                                child: Text(
                              "No Songs found",
                              style: TextStyle(color: Colors.white),
                            ));
                          }
                          startSong = item.data!;
                          if (!FavoriteDb.isInitialized) {
                            FavoriteDb.initialize(item.data!);
                          }
                          GetAllSongController.songscopy = item.data!;
                          return SizedBox(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                allSongs.addAll(item.data!);
                                final SongModel song = item.data![index];
                                final bool isCurrentlyPlaying =
                                    GetAllSongController.currentIndexes >= 0 &&
                                        song.id ==
                                            GetAllSongController
                                                .playingSong[
                                                    GetAllSongController
                                                        .currentIndexes]
                                                .id;

                                return Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: isCurrentlyPlaying
                                          ? Colors.green
                                          : const Color.fromARGB(
                                              255, 81, 21, 88),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF121212),
                                        Color(0xFF292929),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: QueryArtworkWidget(
                                      id: item.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget:
                                          const Icon(Icons.music_note),
                                    ),
                                    title: Text(
                                      item.data![index].displayNameWOExt,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                    iconColor: Colors.white,
                                    subtitle: Text(
                                        "${item.data![index].artist}",
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.blueGrey,
                                            fontSize: 12)),
                                    trailing: FavoriteMenuButton(
                                        songFavorite: startSong[index]),
                                    onTap: () {
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(item.data!),
                                              initialIndex: index);

                                      GetRecentSongController.addRecentlyPlayed(
                                          item.data![index].id);

                                      context
                                          .read<SongModelProvider>()
                                          .setId(item.data![index].id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerScreen(
                                            songModelList: item.data!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 5,
                              ),
                              itemCount: item.data!.length,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: FavoriteDb.favoriteSongs,
                    builder: (BuildContext context, List<SongModel> music,
                        Widget? child) {
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            if (GetAllSongController.audioPlayer.currentIndex !=
                                null)
                              Column(
                                children: const [
                                  MiniPlayer(),
                                ],
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
