import 'package:zema/db/model/zema_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class PlaylistDb {
  static ValueNotifier<List<zemaModel>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<zemaModel>('playlistDb');

  static Future<void> addPlaylist(zemaModel value) async {
    final playlistDb = Hive.box<zemaModel>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<zemaModel>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<zemaModel>('playlistDb');
    await playlistDb.deleteAt(index);
    getAllPlaylist();
  }

  static Future<void> editList(int index, zemaModel value) async {
    final playlistDb = Hive.box<zemaModel>('playlistDb');
    await playlistDb.putAt(index, value);
    getAllPlaylist();
  }
}
