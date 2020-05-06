import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:qeydlerim/widgets/notecard.dart';
import 'package:qeydlerim/widgets/threedots.dart';

class Archieved extends StatelessWidget {
  DatabaseService databaseService = new DatabaseService();

  List<Note> archievedNotes = [];

  _getArchievedNotes() async {
    await databaseService
        .getArchievedNotesList()
        .then((fetchedNotes) => archievedNotes = fetchedNotes);
    return archievedNotes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context),
        body: _body(),
      ),
    );
  }

  FutureBuilder _body() {
    return FutureBuilder(
        future: _getArchievedNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ThreeDots();
          }
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text("No archieved notes."),
            );
          }
          return _displayArchievedNotes(snapshot.data);
        },
      );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Archieve",
          style: TextStyle(color: Colors.black),
        ),
      );
  }

  Widget _displayArchievedNotes(List<Note> archievedNotes) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: archievedNotes.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NoteCard(note: archievedNotes[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
