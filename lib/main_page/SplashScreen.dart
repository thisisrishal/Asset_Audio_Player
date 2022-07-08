import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musico_scratch/database/dbSongs.dart';
import 'package:musico_scratch/main_page/home_tab.dart';
import 'package:musico_scratch/presentation/songs/songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // requestPermission();
    // Permission.storage.request();
    requestPermission();

    // fetchsongs();

    super.initState();

    fetchArtist();
  }

  final _audioQuery = new OnAudioQuery();

// open the box
  final box = MusicBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Image.asset('assets/images/ic_launcher.png'),
        ),
      ),
    );
  }

  void requestPermission() async {
    var requestStatus = await Permission.storage.request();
    if (requestStatus.isDenied) {
      // print('++++++++++++++++++++++++++');
      requestPermission();
    } else if (requestStatus.isGranted) {
      fetchsongs();
    }
  }

//fetch all Artist
  void fetchArtist() async {
    List<ArtistModel> fetchallArtists = await _audioQuery.queryArtists();
    for (var song in fetchallArtists) {
      if (song.artist != '<unknown>') {
        allArtistsSet.add(song);
      }
    }
  }

//fetch all songs
  fetchsongs() async {
    // print('***********444***********');

    fetchedSongs = await _audioQuery.querySongs();
    // print('***********777***********');

// return all mp3 Songs;
    for (var song in fetchedSongs) {
      if (song.fileExtension == 'mp3') {
        allSongs.add(song);
      }
    }

// itereting every song in all song && got the title,artist.....id
//and assing it to the mappedSong as a list
    mappedSongs = allSongs.map((audio) {
      return dbSongs(
        title: audio.title,
        artist: audio.artist,
        uri: audio.uri,
        duration: audio.duration,
        id: audio.id,
      );
    }).toList();

    // navigate();
    await box.put('musics', mappedSongs);
    recievedDatabaseSongs = box.get('musics') as List<dbSongs>;

    // convert it to the type Audio
    for (var element in recievedDatabaseSongs) {
      databaseAudioList.add(
        Audio.file(element.uri.toString(),
            metas: Metas(
                title: element.title,
                artist: element.artist,
                id: element.id.toString())),
      );
    }
    navigate();
  }

  navigate() async {
    // print('**********************');
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeTab(),
      ),
    );
  }
}
