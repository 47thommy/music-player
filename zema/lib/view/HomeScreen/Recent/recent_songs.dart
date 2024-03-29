import 'package:zema/controller/get_all_song.dart';
import 'package:zema/view/MusicPlayer/musicplayer.dart';
import 'package:zema/view/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controller/get_recent_controller.dart';
import '../../../db/favourite_db.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  @override
  void initState() {
    super.initState();
    init();
    setState(() {});
  }

  Future init() async {
    await GetRecentSongController.getRecentSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FavoriteDb.favoriteSongs;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF121212),
        title: const Text('Recent Songs'),
      ),
      body: Container(
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
        child: FutureBuilder(
          future: GetRecentSongController.getRecentSongs(),
          builder: (context, items) {
            return ValueListenableBuilder(
              valueListenable: GetRecentSongController.recentSongNotifier,
              builder:
                  (BuildContext context, List<SongModel> value, Widget? child) {
                if (value.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        'No Song played recently',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  final temp = value.reversed.toList();
                  recentSong = temp.toSet().toList();
                  return FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, items) {
                      if (items.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (items.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Song Available',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 5, right: 5),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromARGB(255, 81, 21, 88),
                                ),
                              ),
                              child: ListTile(
                                iconColor: Colors.white,
                                selectedColor: Colors.purpleAccent,
                                leading: QueryArtworkWidget(
                                    id: recentSong[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget:
                                        const Icon(Icons.music_note)),
                                title: Text(
                                  recentSong[index].displayNameWOExt,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'poppins',
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${recentSong[index].artist == "<unknown>" ? "Unknown Artist" : recentSong[index].artist}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontFamily: 'poppins',
                                      fontSize: 12,
                                      color: Colors.blueGrey),
                                ),
                                trailing: FavoriteMenuButton(
                                    songFavorite: recentSong[index]),
                                onTap: () {
                                  GetAllSongController.audioPlayer
                                      .setAudioSource(
                                          GetAllSongController.createSongList(
                                              recentSong),
                                          initialIndex: index);
                                  GetAllSongController.audioPlayer.play();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return PlayerScreen(
                                      songModelList:
                                          GetAllSongController.playingSong,
                                    );
                                  }));
                                },
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) => const Divider(
                          height: 5,
                        ),
                        itemCount: recentSong.length,
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
