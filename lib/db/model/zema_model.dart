import 'dart:developer';

import 'package:hive/hive.dart';
part 'zema_model.g.dart';

@HiveType(typeId: 1)
class zemaModel extends HiveObject {
  zemaModel({required this.name, required this.songId});

  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> songId;

  add(int id) async {
    songId.add(id);
    save();
    log('song added $id');
  }

  deleteData(int id) {
    songId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songId.contains(id);
  }
}
