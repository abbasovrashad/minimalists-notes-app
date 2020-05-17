import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/screens/add.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:qeydlerim/widgets/menudrawer.dart';
import 'package:qeydlerim/widgets/notecard.dart';
import 'package:qeydlerim/widgets/threedots.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DatabaseService databaseService = new DatabaseService();

  Future<List<Note>> _getNotes() async {
    return await databaseService.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MenuDrawer(),
        appBar: _appBar(),
        body: _body(),
        floatingActionButton: _addButton(context),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      tooltip: "Add",
      label: Icon(Icons.add),
      onPressed: () => Navigator.push(
          context, CupertinoPageRoute(builder: (context) => Add())),
    );
  }

  Widget _body() {
    return FutureBuilder(
      future: _getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text(
                "No notes, yet.",
                style: Theme.of(context).textTheme.body1,
              ),
            );
          } else {
            Provider.of<NotesProvider>(context).showSearch = true;
            return displayNotes(snapshot);
          }
        }
        return ThreeDots();
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.sort, color: Colors.black),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      backgroundColor: Colors.white,
      title: Text(
        "minimalist's notes",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0.0,
      actions: Provider.of<NotesProvider>(context).showSearch
          ? <Widget>[]
          : <Widget>[
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      // TODO: add search functionality
                    },
                  );
                },
              ),
            ],
    );
  }

  Widget displayNotes(snapshot) => AnimationLimiter(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: NoteCard(note: snapshot.data[index]),
                ),
              ),
            );
          },
        ),
      );
}
