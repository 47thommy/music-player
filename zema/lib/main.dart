import 'package:zema/controller/provider/search_provider.dart';
import 'package:zema/db/model/zema_model.dart';
import 'package:zema/controller/provider/provider.dart';
import 'package:zema/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(zemaModelAdapter().typeId)) {
    Hive.registerAdapter(zemaModelAdapter());
  }

  await Hive.openBox('recentSongNotifier');
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<zemaModel>('playlistDb');

  await JustAudioBackground.init(
      androidNotificationChannelId: 'com.zema.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SongModelProvider()),
        ChangeNotifierProvider(create: (context) => SearchScreenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zema',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, fontFamily: 'PoppinsMedium'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
