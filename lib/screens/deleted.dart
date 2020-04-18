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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Silinənlər",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: _getDeletedNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ThreeDots();
          }
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text("Silinmiş qeydiniz yoxdur.",
                  style: Theme.of(context).textTheme.body1),
            );
          }
          return _displayDeletedNotes(snapshot.data);
        },
      ),
    );
  }

  Widget _displayDeletedNotes(List<Note> deletedNotes){
    return AnimationLimiter(
      child: ListView.builder(
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
