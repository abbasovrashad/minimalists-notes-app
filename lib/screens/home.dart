import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/screens/add.dart';
import 'package:qeydlerim/screens/view.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:qeydlerim/widgets/menudrawer.dart';
import 'package:qeydlerim/widgets/notecard.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseService databaseService = new DatabaseService();

  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _updateNotesList();
  }

  Future<List<Note>> _updateNotesList() async {
    Future<Database> init = databaseService.initializeDatabase();
    init.then((database) {
      Future<List<Note>> listOfNotes = databaseService.getNoteList();
      listOfNotes.then((notesList) {
        return listOfNotes;
      });
    });

    await databaseService.getNoteList().then((notesList) => notes = notesList);
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MenuDrawer(),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.sort, color: Colors.black),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Qeydlərim",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.0,
          actions: notes.isEmpty
              ? <Widget>[]
              : <Widget>[
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
        ),
        body: FutureBuilder(
          future: _updateNotesList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text("...", style: TextStyle(fontSize: 50.0)));
            }
            if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "Qeydləriniz yoxdur.",
                  style: Theme.of(context).textTheme.body1,
                ),
              );
            }
            return displayNotes(snapshot.data);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          tooltip: "Əlavə et",
          label: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Add())),
        ),
      ),
    );
  }

  Widget displayNotes(notesProvider) => AnimationLimiter(
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: NoteCard(note: notes[index]),
                ),
              ),
            );
          },
        ),
      );
}
