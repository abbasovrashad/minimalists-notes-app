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

  _getArchievedNotes() async {
    return await databaseService.getArchievedNotesList();
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
      future: _getArchievedNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Text(
                "No archieved notes.",
                style: Theme.of(context).textTheme.body1,
              ),
            );
          } else {
            return _displayArchievedNotes(snapshot.data);
          }
        }
        return ThreeDots();
      },
    );
  }

  Widget _appBar(BuildContext context) {
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
