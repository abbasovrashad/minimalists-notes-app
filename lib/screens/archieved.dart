import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:qeydlerim/widgets/notecard.dart';
import 'package:qeydlerim/widgets/threedots.dart';

class Archieved extends StatefulWidget {
  @override
  _ArchievedState createState() => _ArchievedState();
}

class _ArchievedState extends State<Archieved> {
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Arxiv",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: _getArchievedNotes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ThreeDots();
            }
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text("Arxivlənmiş qeydiniz yoxdu."),
              );
            }
            return _displayArchievedNotes(snapshot.data);
          },
        ),
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
