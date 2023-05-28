import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  String? image;
  String? artist;

  MusicCard(this.image, this.artist);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180,
        height: 240,
        child: Card(
          elevation: 10.0,
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              Image.network(
                this.image!,
                fit: BoxFit.cover,
                // width: 180,
                // height: 180,
              ),
              Text(this.artist!),
            ],
          ),
        ));
  }
}

class MusicCardListView extends StatelessWidget {
  List<Map<String, String>>? musicList;
  MusicCardListView(this.musicList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: musicList!.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return MusicCard(
            musicList![index]['image'],
            musicList![index]['artist'],
          );
        },
      ),
    );
  }
}

    // return ListView.builder(
    //     // scrollDirection: Axis.horizontal,
    //     shrinkWrap: true,
    //     scrollDirection: Axis.horizontal,
    //     itemCount: musicList!.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return ListTile(
    //           leading: MusicCard(
    //               musicList![index]['image'], musicList![index]['artist']));
    //     });
