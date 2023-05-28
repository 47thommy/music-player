import 'package:flutter/material.dart';
import 'ui/card.dart';
import 'home.dart';

void main() => {runApp(MyApp())};

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final Color myColor = Color.fromRGBO(29, 11, 45, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmony Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: myColor,
          background: Colors.black, // set background color here
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text('discover'),
    Text('playlist'),
    Text('profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harmony Hub"),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 0, 255, 247),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'playlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
