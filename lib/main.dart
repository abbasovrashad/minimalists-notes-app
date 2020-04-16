import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<NotesProvider>(
      create: (context) => NotesProvider(),
      child: MyApp(),
    ),
  );
  // SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 20.0),
        ),
        fontFamily: "Exo2",
        primaryColor: Colors.black,
        accentColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Home(),
      title: "DailyJ",
    );
  }
}
