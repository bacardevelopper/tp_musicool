import 'package:flutter/material.dart';

// enum pour differencier les boutons
enum ActionMusic { play, pause, rewind, forward }
// état de mon audio player
enum PlayerState { playing, stopped, paused }
/* ---- */
Text textDecCenter(String data, double f) {
  return new Text(
    data,
    textAlign: TextAlign.center,
    textScaleFactor: f,
    style: new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: 15.0,
    ),
  );
}

Text text(String data, double scale) {
  return new Text(
    data,
    textScaleFactor: scale,
    style: new TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontStyle: FontStyle.italic,
    ),
  );
}

/* ---- */
Container marginTopBottom(double larg) {
  return new Container(
    height: larg,
  );
}

