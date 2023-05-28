import 'package:flutter/material.dart';
import 'ui/card.dart';

class Home extends StatelessWidget {
  final List<Map<String, String>> musicList = [
    {
      'image': 'https://source.unsplash.com/800x800/?music',
      'artist': 'John Doe',
    },
    {
      'image': 'https://source.unsplash.com/800x800/?music',
      'artist': 'Jane Smith',
    },
    {
      'image': 'https://source.unsplash.com/800x800/?music',
      'artist': 'Bob Johnson',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Perfect For You",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Column(children: [
            MusicCardListView(musicList),
            // ),
          ])
        ],
      ),
    ]);
  }
}
