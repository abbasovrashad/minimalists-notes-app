import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/screens/screens.dart';

void main() {
  runApp(
    ChangeNotifierProvider<NotesProvider>(
      create: (context) => NotesProvider(),
      child: MyApp(),
    ),
  );
  
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
          body2: TextStyle(fontSize: 18.0),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
        ),
        fontFamily: "Quicksand",
        primaryColor: Colors.black,
        accentColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(), 
        "/deleted": (context) => Deleted(), 
        "/archieved": (context) => Archieved(),
        "/settings": (context) => Settings(),
      },
      title: "minimalist's notes",
    );
  }
}
