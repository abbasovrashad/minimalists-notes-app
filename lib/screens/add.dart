import 'package:flutter/material.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:provider/provider.dart';
import 'package:qeydlerim/widgets/custom_toast.dart';

class Add extends StatelessWidget {
  DatabaseService databaseService = new DatabaseService();
  Note note;

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);
    // clear previous title and note caches from state
    notesProvider.nullify();
    return SafeArea(
      child: Scaffold(
        appBar: _appbar(context, notesProvider),
        body: _body(notesProvider, context),
        floatingActionButton: _addButton(notesProvider, context),
      ),
    );
  }

  Widget _addButton(NotesProvider notesProvider, context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.black,
      onPressed: () => _add(notesProvider, context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      icon: Icon(Icons.save),
      label: Text("ADD"),
    );
  }

  Widget _body(NotesProvider notesProvider, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        onChanged: (description) => notesProvider.description = description,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          hintText: "note..",
          hintStyle: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.black54,
              ),
          border: InputBorder.none,
        ),
        // makes input length bigger than screen size
        // so that wherever user taps on the screen, it activates
        maxLines: (MediaQuery.of(context).size.height).ceil(),
      ),
    );
  }

  Widget _appbar(BuildContext context, NotesProvider notesProvider) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        style: Theme.of(context).textTheme.body1,
        onChanged: (title) => notesProvider.title = title,
        decoration: InputDecoration(
          hintText: "title..",
          hintStyle: Theme.of(context).textTheme.body1.copyWith(
                color: Colors.black54,
              ),
          border: InputBorder.none,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
    );
  }

  void _add(notesProvider, context) async {
    if (notesProvider.description == null ||
        notesProvider.description.length == 0) {
      CustomToast.display(text: "NOTE IS EMPTY", positive: false);
    } else {
      note = new Note(notesProvider.title, notesProvider.description,
          DateTime.now().toIso8601String(), 1, 0, 0);
      int result = await databaseService.insert(note);
      if (result != null) {
        CustomToast.display(text: "NOTE ADDED", positive: true);
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      }
    }
  }
}
