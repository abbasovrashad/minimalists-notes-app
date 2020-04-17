import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qeydlerim/models/note.dart';
import 'package:qeydlerim/providers/notes.dart';
import 'package:qeydlerim/services/database.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  DatabaseService databaseService = new DatabaseService();
  Note note;

  @override
  Widget build(BuildContext context) {
    var notesProvider = Provider.of<NotesProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            style: Theme.of(context).textTheme.body1,
            onChanged: (title) => notesProvider.title = title,
            decoration: InputDecoration(
              hintText: "başlıq..",
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            onChanged: (description) => notesProvider.description = description,
            style: Theme.of(context).textTheme.body1,
            decoration: InputDecoration(
              hintText: "qeydiniz..",
              hintStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.black54),
              border: InputBorder.none,
            ),
            maxLines: (MediaQuery.of(context).size.height).ceil(),
            // decoration: ,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () => _add(notesProvider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          icon: Icon(Icons.save),
          label: Text("ƏLAVƏ ET"),
        ),
      ),
    );
  }

  void _add(notesProvider) async {
    if (notesProvider.description == null ||
        notesProvider.description.length == 0) {
      print(notesProvider.title);
      Fluttertoast.showToast(
        msg: "QEYD YAZMADINIZ!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 18.0,
      );
    } else {
      note = new Note(
        notesProvider.title,
        notesProvider.description,
        DateTime.now().toIso8601String(),
        1,
      );
      notesProvider.nullify();
      await databaseService.insert(note);
      Fluttertoast.showToast(
        msg: "QEYD ƏLAVƏ OLUNDU!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 18.0,
      );
    }
  }
}
