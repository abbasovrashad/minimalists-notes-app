import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:provider/provider.dart';

class Add extends StatelessWidget {
  DatabaseService databaseService = new DatabaseService();
  Note note;

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);
    notesProvider.nullify();
    return SafeArea(
      child: Scaffold(
        appBar: _appbar(context, notesProvider),
        body: _body(notesProvider, context),
        floatingActionButton: _addButton(notesProvider),
      ),
    );
  }

  FloatingActionButton _addButton(NotesProvider notesProvider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.black,
      onPressed: () => _add(notesProvider),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      icon: Icon(Icons.save),
      label: Text("ADD"),
    );
  }

  Container _body(NotesProvider notesProvider, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        onChanged: (description) => notesProvider.description = description,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          hintText: "[your note]",
          hintStyle:
              Theme.of(context).textTheme.body1.copyWith(color: Colors.black54),
          border: InputBorder.none,
        ),
        maxLines: (MediaQuery.of(context).size.height).ceil(),
        // decoration: ,
      ),
    );
  }

  AppBar _appbar(BuildContext context, NotesProvider notesProvider) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        style: Theme.of(context).textTheme.body1,
        onChanged: (title) => notesProvider.title = title,
        decoration: InputDecoration(
          hintText: "[title]",
          hintStyle:
              Theme.of(context).textTheme.body1.copyWith(color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
    );
  }

  void _add(notesProvider) async {
    if (notesProvider.description == null ||
        notesProvider.description.length == 0) {
      print(notesProvider.title);
      Fluttertoast.showToast(
        msg: "NOTE IS EMPTY",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } else {
      note = new Note(notesProvider.title, notesProvider.description,
          DateTime.now().toIso8601String(), 1, 0, 0);

      await databaseService.insert(note);
      Fluttertoast.showToast(
        msg: "NOTE ADDED",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }
}
