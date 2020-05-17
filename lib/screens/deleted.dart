import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:qeydlerim/widgets/notecard.dart';
import 'package:qeydlerim/widgets/threedots.dart';

class Deleted extends StatefulWidget {
  @override
  _DeletedState createState() => _DeletedState();
}

class _DeletedState extends State<Deleted> {
  List<Note> deletedNotes = new List<Note>();

  DatabaseService databaseService = new DatabaseService();

  _getDeletedNotes() async {
    return await databaseService.getDeletedNotesList();
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

  Widget _body() {
    return FutureBuilder(
      future: _getDeletedNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text(
                "No deleted notes.",
                style: Theme.of(context).textTheme.body1,
              ),
            );
          } else {
            return _displayDeletedNotes(snapshot.data);
          }
        }

        return ThreeDots();
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
        "Deleteds",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _displayDeletedNotes(List<Note> deletedNotes) {
    return AnimationLimiter(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: deletedNotes.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NoteCard(note: deletedNotes[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
