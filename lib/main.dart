import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musicool/widgetwork.dart';
import 'package:musicool/musique.dart';
import 'package:audioplayer2/audioplayer2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicool',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Musicool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* mes variables */
  int index = 0;
  List<Music> maListe = [
    new Music("verité 3", "ISK", dataImageUrl,
        "https://codabee.com/wp-content/uploads/2018/06/un.mp3"),
    new Music("changes", "2pac", dataImageUrl,
        "https://codabee.com/wp-content/uploads/2018/06/deux.mp3"),
  ];
  Music musiqueActu;
  Duration position = new Duration(seconds: 0);
  Duration duree = new Duration(seconds: 0);
  AudioPlayer playerAudio;
  // ignore: cancel_subscriptions
  StreamSubscription positionSub;
  // ignore: cancel_subscriptions
  StreamSubscription stateSubscription;
  // variable type PlayerState
  PlayerState statut = PlayerState.stopped;
  /* quand l'état va etre initialisé */
  @override
  void initState() {
    super.initState();
    musiqueActu = maListe[index];
    // configAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.red]),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            marginTopBottom(30),
            new Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 2.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: new Image.network(
                  musiqueActu.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            marginTopBottom(20),
            // textDecoratif
            textDecCenter(musiqueActu.titre, 1.9),
            textDecCenter(musiqueActu.artiste, 1.3),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  bouton(Icons.fast_rewind_rounded, 37, ActionMusic.rewind),
                  bouton(Icons.play_arrow_rounded, 58, ActionMusic.play),
                  bouton(Icons.fast_forward_rounded, 37, ActionMusic.forward),
                ]),
            marginTopBottom(20),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                text(timeMusic(position), 0.8),
                text(timeMusic(duree), 0.8),
              ],
            ),
            new Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: 30.0,
              inactiveColor: Colors.black,
              activeColor: Colors.white,
              onChanged: (double d) {
                /* la position du curseur de slider sera = d */
                setState(() {
                  Duration newDuree = new Duration(seconds: d.toInt());
                  position = newDuree;
                  playerAudio.seek(d);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // config audioplayer2
  void configAudio() {
    playerAudio = new AudioPlayer();
    positionSub = playerAudio.onAudioPositionChanged
        .listen((pos) => setState(() => position = pos));

    stateSubscription = playerAudio.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          duree = playerAudio.duration;
        });
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    }, onError: () {
      print("erreur");
      statut = PlayerState.stopped;
      duree = new Duration(seconds: 0);
      position = new Duration(seconds: 0);
    });
  }

  /* -- les methodes ---------------------------- */
  Future play() async {
    await playerAudio.play(musiqueActu.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }

  // ---------------------------
  Future pause() async {
    await playerAudio.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  // --
  void forward() {
    if (index == maListe.length - 1) {
      index = 0;
    } else {
      index++;
    }
    musiqueActu = maListe[index];
    playerAudio.stop();
    configAudio();
    play();
  }

  void rewind() {
    if (position > Duration(seconds: 3)) {
      playerAudio.seek(0.0); // revenir au debut de la musique
    } else {
      if (index == 0) {
        index = maListe.length - 1;
      } else {
        index--;
      }
      musiqueActu = maListe[index];
      playerAudio.stop();
      configAudio();
      play();
    }
  }

  String timeMusic(Duration duree) {
    return duree.toString().split('.').first;
  }

  /* ---- */
  IconButton bouton(IconData iconeData, double sizerT, ActionMusic action) {
    return new IconButton(
      iconSize: sizerT,
      color: Colors.white,
      icon: new Icon(iconeData),
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.forward:
            forward();
            break;
          case ActionMusic.rewind:
            rewind();
            break;
          case ActionMusic.pause:
            pause();
            break;
        }
      },
    );
  }
}
