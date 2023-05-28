import 'package:flutter/material.dart';
import 'ui/card.dart';
// import 'ui/horizontal_card_listview.dart';

void main() => {runApp(MyApp())};

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final Color myColor = Color.fromRGBO(29, 11, 45, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmony Hub',
      color: myColor,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Harmony Hub"),
      ),
      body: Column(children: [
        TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search Music",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ),
        Column(
          children: [
            Text(
              "Perfect For You",
              textAlign: TextAlign.right,
            ),
            Column(children: [
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              MusicCardListView(musicList),
              // ),
            ])
          ],
        ),
      ]),
    );
  }
}
