import 'package:zema/db/model/zema_model.dart';
import 'package:zema/db/playlist_db.dart';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListAddPage extends StatefulWidget {
  const SongListAddPage({super.key, required this.playlist});
  final zemaModel playlist;
  @override
  State<SongListAddPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListAddPage> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF121212),
          centerTitle: true,
          title: const Text('Add Songs'),
        ),
        backgroundColor: Color(0xFF121212),
        body: SafeArea(
          child: Container(
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
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: FutureBuilder<List<SongModel>>(
                            future: audioQuery.querySongs(
                                sortType: null,
                                orderType: OrderType.ASC_OR_SMALLER,
                                uriType: UriType.EXTERNAL,
                                ignoreCase: true),
                            builder: (context, item) {
                              if (item.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (item.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Song Available',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'poppins'),
                                  ),
                                );
                              }
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 10,
                                ),
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: ListTile(
                                          iconColor: Colors.white,
                                          selectedColor: Colors.purpleAccent,
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
                                                fontFamily: 'poppins',
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 12,
                                                color: Colors.blueGrey),
                                          ),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Wrap(children: [
                                              !widget.playlist.isValueIn(
                                                      item.data![index].id)
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          songAddPlaylist(item
                                                              .data![index]);

                                                          PlaylistDb
                                                              .playlistNotifier
                                                              .notifyListeners();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ))
                                                  : IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          widget.playlist
                                                              .deleteData(item
                                                                  .data![index]
                                                                  .id);
                                                        });
                                                        const snackBar =
                                                            SnackBar(
                                                          content: Text(
                                                            'Song deleted from playlist',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  450),
                                                        );
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      },
                                                      icon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 25),
                                                        child: Icon(
                                                          Icons.minimize,
                                                          color: Colors.white,
                                                        ),
                                                      ))
                                            ]),
                                          )),
                                    ),
                                  );
                                }),
                                itemCount: item.data!.length,
                              );
                            })),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void songAddPlaylist(SongModel data) {
    widget.playlist.add(data.id);
    const snackBar1 = SnackBar(
        content: Text(
      'Song added to Playlist',
      style: TextStyle(color: Colors.white, fontFamily: 'poppins'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }
}
