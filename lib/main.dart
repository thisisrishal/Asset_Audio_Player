import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musico_scratch/database/dbSongs.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musico_scratch/screens/splashScree.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // binded to the flutter engine

  await Hive.initFlutter(); //initialize with a path
  Hive.registerAdapter(
      dbSongsAdapter()); //  announcing to hive that this adapter is registering
  await Hive.openBox<List>(boxname); //Opening Hive box globally
  await Hive.openBox<List>(boxname1); //for playlist and favourites

  runApp(const Musico());

  //  check if the favourites containes or not - otherwise we get null
  // if not created an empty box and assign it has the value to the "favourites" key
  final box = MusicBox.getInstance();
  List<dynamic> favKeys = box.keys.toList();
  if (!favKeys.contains("favourites")) {
    List<dynamic> likedSongs = [];
    await box.put("favourites", likedSongs);
  }
}

class Musico extends StatelessWidget {
  const Musico({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musico',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color.fromARGB(255, 241, 241, 242),
              displayColor: Colors.grey[500],
            ),
      ),
      home: const SplashScreen(),
    );
  }
}
