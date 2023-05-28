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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                this.image!,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  this.artist!,
                  textAlign: TextAlign.start,
                ),
              )
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
